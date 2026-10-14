Omen.configure do |config|
  config.narrow_role = 'basic_inquirer'
  config.notes = Rails.root.join 'config/omen/notes.md'
end

# Declared on the gem's own class, so a reading loaded as an Omen::Reading broadcasts as well.
ActiveSupport.on_load(:omen_reading) { broadcasts_refreshes }
