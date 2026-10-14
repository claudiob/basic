ActiveSupport::Inflector.inflections do |inflect|
  %w[ PIN ].each { |acronym| inflect.acronym acronym }
end
