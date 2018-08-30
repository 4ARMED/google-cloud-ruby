# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: google/bigtable/admin/v2/bigtable_instance_admin.proto for package 'google.bigtable.admin.v2'
# Original file comments:
# Copyright 2018 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


require 'grpc'
require 'google/bigtable/admin/v2/bigtable_instance_admin_pb'

module Google
  module Bigtable
    module Admin
      module V2
        module BigtableInstanceAdmin
          # Service for creating, configuring, and deleting Cloud Bigtable Instances and
          # Clusters. Provides access to the Instance and Cluster schemas only, not the
          # tables' metadata or data stored in those tables.
          class Service

            include GRPC::GenericService

            self.marshal_class_method = :encode
            self.unmarshal_class_method = :decode
            self.service_name = 'google.bigtable.admin.v2.BigtableInstanceAdmin'

            # Create an instance within a project.
            rpc :CreateInstance, CreateInstanceRequest, Google::Longrunning::Operation
            # Gets information about an instance.
            rpc :GetInstance, GetInstanceRequest, Instance
            # Lists information about instances in a project.
            rpc :ListInstances, ListInstancesRequest, ListInstancesResponse
            # Updates an instance within a project.
            rpc :UpdateInstance, Instance, Instance
            # Partially updates an instance within a project.
            rpc :PartialUpdateInstance, PartialUpdateInstanceRequest, Google::Longrunning::Operation
            # Delete an instance from a project.
            rpc :DeleteInstance, DeleteInstanceRequest, Google::Protobuf::Empty
            # Creates a cluster within an instance.
            rpc :CreateCluster, CreateClusterRequest, Google::Longrunning::Operation
            # Gets information about a cluster.
            rpc :GetCluster, GetClusterRequest, Cluster
            # Lists information about clusters in an instance.
            rpc :ListClusters, ListClustersRequest, ListClustersResponse
            # Updates a cluster within an instance.
            rpc :UpdateCluster, Cluster, Google::Longrunning::Operation
            # Deletes a cluster from an instance.
            rpc :DeleteCluster, DeleteClusterRequest, Google::Protobuf::Empty
            # Creates an app profile within an instance.
            rpc :CreateAppProfile, CreateAppProfileRequest, AppProfile
            # Gets information about an app profile.
            rpc :GetAppProfile, GetAppProfileRequest, AppProfile
            # Lists information about app profiles in an instance.
            rpc :ListAppProfiles, ListAppProfilesRequest, ListAppProfilesResponse
            # Updates an app profile within an instance.
            rpc :UpdateAppProfile, UpdateAppProfileRequest, Google::Longrunning::Operation
            # Deletes an app profile from an instance.
            rpc :DeleteAppProfile, DeleteAppProfileRequest, Google::Protobuf::Empty
            # Gets the access control policy for an instance resource. Returns an empty
            # policy if an instance exists but does not have a policy set.
            rpc :GetIamPolicy, Google::Iam::V1::GetIamPolicyRequest, Google::Iam::V1::Policy
            # Sets the access control policy on an instance resource. Replaces any
            # existing policy.
            rpc :SetIamPolicy, Google::Iam::V1::SetIamPolicyRequest, Google::Iam::V1::Policy
            # Returns permissions that the caller has on the specified instance resource.
            rpc :TestIamPermissions, Google::Iam::V1::TestIamPermissionsRequest, Google::Iam::V1::TestIamPermissionsResponse
          end

          Stub = Service.rpc_stub_class
        end
      end
    end
  end
end