require "bundler/setup"
require "fileutils"
require "json"
require "open3"

require_relative "command.rb"
require_relative "kokoro_builder.rb"

class Kokoro < Command
  attr_reader :tag

  def initialize ruby_versions, gems, updated_gems, gem: nil
    @ruby_versions = ruby_versions
    @gems          = gems
    @updated_gems  = updated_gems
    @gem           = gem

    @builder = KokoroBuilder.new ruby_versions, gems
    @failed  = false
    @tag     = nil
    @updated = @updated_gems.include? @gem
  end

  def build
    @builder.build
  end

  def publish
    @builder.publish
  end

  def presubmit
    run_ci do
      run "bundle exec rake ci", 1800
    end
  end

  def continuous
    run_ci do
      if @updated
        header "Gem Updated - Running Acceptance"
        run "bundle exec rake ci:acceptance", 3600
        release_please if ENV.fetch("OS", "") == "linux"
      else
        header "Gem Unchanged - Skipping Acceptance"
        run "bundle exec rake ci", 3600
      end
    end
  end

  def nightly
    run_ci do
      run "bundle exec rake ci:acceptance", 3600
      release_please if ENV.fetch("OS", "") == "linux"
    end
  end

  def post
    job_info
    git_commit = ENV.fetch "KOKORO_GITHUB_COMMIT", "master"

    markdown_files = Dir.glob "**/*.md"
    broken_markdown_links = check_links markdown_files,
                                        "https://github.com/googleapis/google-cloud-ruby/tree/#{git_commit}/",
                                        " --skip '^(?!(\\Wruby.*google|.*google.*\\Wruby|.*cloud\\.google\\.com))'"

    broken_devsite_links = check_links @gems,
                                       "https://googleapis.dev/ruby/",
                                       "/latest/ --recurse --skip https:.*github.*"

    puts_broken_links broken_markdown_links
    puts_broken_links broken_devsite_links
  end

  def release
    load_env_vars
    raise "RUBYGEMS_API_TOKEN must be set" if ENV["RUBYGEMS_API_TOKEN"].nil? || ENV["RUBYGEMS_API_TOKEN"].empty?
    @tag = "#{@gem}/v#{version}"
  end

  def exit_status
    @failed ? 1 : 0
  end

  def check_links location_list, base, tail
    broken_links = Hash.new { |h, k| h[k] = [] }
    location_list.each do |location|
      out, err, st = Open3.capture3 "npx linkinator #{base}/#{location}#{tail}"
      puts out
      unless st.to_i.zero?
        @failed = true
        puts err
      end
      checked_links = out.split "\n"
      checked_links.select! { |link| link =~ /\[\d+\]/ && !link.include?("[200]") }
      unless checked_links.empty?
        @failed = true
        broken_links[location] += checked_links
      end
    end
    broken_links
  end

  def header str, token = "#"
    line_length = str.length + 8
    puts ""
    puts token * line_length
    puts "#{token * 3} #{str} #{token * 3}"
    puts token * line_length
    puts ""
  end

  def header_2 str, token = "#"
    puts "\n#{token * 3} #{str} #{token * 3}\n"
  end

  def job_info gem = nil
    header "Using Ruby - #{RUBY_VERSION}"
    header_2 "Job Type: #{ENV['JOB_TYPE']}"
    header_2 "Package: #{gem || @gem}"
    puts ""
  end

  def load_env_vars
    service_account = "#{ENV['KOKORO_GFILE_DIR']}/service-account.json"
    raise "#{service_account} is not a file" unless File.file? service_account
    ENV["GOOGLE_APPLICATION_CREDENTIALS"] = service_account
    filename = "#{ENV['KOKORO_GFILE_DIR']}/env_vars.json"
    raise "#{filename} is not a file" unless File.file? filename
    env_vars = JSON.parse File.read(filename)
    env_vars.each { |k, v| ENV[k] = v }
  end

  def puts_broken_links link_hash
    link_hash.each do |location, links|
      puts "#{location} contains the following broken links:"
      links.each { |link| puts "  #{link}" }
      puts ""
    end
  end

  def release_please gem = nil, token = nil
    gem ||= @gem
    token ||= "#{ENV['KOKORO_KEYSTORE_DIR']}/73713_yoshi-automation-github-key"
    opts = {
      "package-name"         => gem,
      "last-package-version" => version(gem),
      "release-type"         => "ruby-yoshi",
      "repo-url"             => "googleapis/google-cloud-ruby",
      "token"                => token
    }.to_a.map { |a| "--#{a[0]}=#{a[1]}" }.join(" ")
    header_2 "Running release-please for #{gem}, since #{version gem}"
    run "npx release-please release-pr #{opts}"
  end

  def release_please_all token = nil
    @gems.each do |gem|
      release_please gem, token
    end
  end

  def run_ci gem = nil, local = false
    gem ||= @gem
    job_info gem
    Dir.chdir gem do
      Bundler.with_clean_env do
        run "bundle update"
        load_env_vars unless local
        windows_acceptance_fix unless local
        yield
      end
    end
    verify_in_gemfile unless local
  end

  def verify_in_gemfile
    return if Bundler.environment.gems.map(&:name).include? @gem
    header_2 "#{@gem} does not appear in the top-level Gemfile. Please add it."
    @failed = true
  end

  def version gem = nil
    version = "0.1.0"
    gem ||= @gem
    run_ci gem, true do
      version = `bundle exec gem list`
                .split("\n").select { |line| line.include? gem }
                .first.split("(").last.split(")").first
    end
    version
  end

  def windows_acceptance_fix
    if ENV["OS"] == "windows"
      FileUtils.mkdir_p "acceptance"
      if File.file? "acceptance/data"
        FileUtils.rm_f "acceptance/data"
        run "call mklink /j acceptance\\data ..\\acceptance\\data"
        puts err if st.to_i != 0
      end
    end
  end
end
