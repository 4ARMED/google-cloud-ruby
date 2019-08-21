# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: google/cloud/tasks/v2/task.proto


require 'google/protobuf'

require 'google/cloud/tasks/v2/target_pb'
require 'google/protobuf/duration_pb'
require 'google/protobuf/timestamp_pb'
require 'google/rpc/status_pb'
require 'google/api/annotations_pb'
Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "google.cloud.tasks.v2.Task" do
    optional :name, :string, 1
    optional :schedule_time, :message, 4, "google.protobuf.Timestamp"
    optional :create_time, :message, 5, "google.protobuf.Timestamp"
    optional :dispatch_deadline, :message, 6, "google.protobuf.Duration"
    optional :dispatch_count, :int32, 7
    optional :response_count, :int32, 8
    optional :first_attempt, :message, 9, "google.cloud.tasks.v2.Attempt"
    optional :last_attempt, :message, 10, "google.cloud.tasks.v2.Attempt"
    optional :view, :enum, 11, "google.cloud.tasks.v2.Task.View"
    oneof :message_type do
      optional :app_engine_http_request, :message, 2, "google.cloud.tasks.v2.AppEngineHttpRequest"
    end
  end
  add_enum "google.cloud.tasks.v2.Task.View" do
    value :VIEW_UNSPECIFIED, 0
    value :BASIC, 1
    value :FULL, 2
  end
  add_message "google.cloud.tasks.v2.Attempt" do
    optional :schedule_time, :message, 1, "google.protobuf.Timestamp"
    optional :dispatch_time, :message, 2, "google.protobuf.Timestamp"
    optional :response_time, :message, 3, "google.protobuf.Timestamp"
    optional :response_status, :message, 4, "google.rpc.Status"
  end
end

module Google
  module Cloud
    module Tasks
      module V2
        Task = Google::Protobuf::DescriptorPool.generated_pool.lookup("google.cloud.tasks.v2.Task").msgclass
        Task::View = Google::Protobuf::DescriptorPool.generated_pool.lookup("google.cloud.tasks.v2.Task.View").enummodule
        Attempt = Google::Protobuf::DescriptorPool.generated_pool.lookup("google.cloud.tasks.v2.Attempt").msgclass
      end
    end
  end
end
