# Base class for all controllers.
class ApplicationController < ActionController::Base
  # Set only where someone else picked the verb: an OAuth provider redirecting back cannot POST.
  class_attribute :writes_on_read, default: false, instance_writer: false

  around_action :connect_as_permitted

private

  def connect_as_permitted(&block) = ApplicationRecord.connected_to role: permitted_role, &block

  def permitted_role = writes_on_read || request.unsafe_method? ? :writing : :reading

  def administrate_as(agent)
    Current.agent = agent
    session[:agent_id] = agent.id
  end
end
