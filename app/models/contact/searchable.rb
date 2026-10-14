# Extends Contact to be searchable with Ransack.
module Contact::Searchable extend ActiveSupport::Concern
  class_methods do
    # Returns the attributes that Ransack can use to search or filter.
    def ransackable_attributes(_ = nil) = %w[ name surname phone email ]

    # Returns the name needed by Ransack to search for the specified attributes.
    def search_field = :phone_eq

    # Returns the text to display when the search field is empty.
    def search_prompt = 'Filter by exact phone'

    # Returns the attributes that Ransack can use to sort.
    def ransortable_attributes(_ = nil) = %w[ name created_at ]
  end
end
