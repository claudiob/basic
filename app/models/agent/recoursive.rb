# Extends Agent to be compatible with recourse.
module Agent::Recoursive extend ActiveSupport::Concern
  class_methods do
    # Return the column a combobox shows for an agent.
    def recourse_label = :email

    # Return the order to load all the agents.
    def recourse_order = :email
  end
end
