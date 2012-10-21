module Gitlab
  # Issues API
  class MergeRequests < Grape::API
    before { authenticate! }

    resource :projects do
      #list
      get ":id/merge_requests" do
        project = current_user.projects.find(params[:id])
        present project.merge_requests, with: Entities::MergeRequest
      end
      
      #show
      get ":id/merge_request/:merge_request_id" do
        project = current_user.projects.find(params[:id])
        present project.merge_requests.find(params[:merge_request_id]), with: Entities::MergeRequest
      end

      #create merge_request
      post ":id/merge_requests" do
        attrs = attributes_for_keys [:source_branch, :target_branch, :assignee_id, :title]
        project = current_user.projects.find(params[:id])
        merge_request = project.merge_requests.new(attrs)
        merge_request.author = current_user
        
        if merge_request.save
          merge_request.reload_code
          present merge_request, with: Entities::MergeRequest
        else
          not_found!
        end
      end

      #update merge_request
      put ":id/merge_request/:merge_request_id" do

      end

    end
  end
end
