# Extends Contact to be compatible with recourse.
module Contact::Recoursive extend ActiveSupport::Concern
  class_methods do
    # Return the attributes to hide from these pages.
    def recourse_hidden = %i[ pin ]
  end
end
