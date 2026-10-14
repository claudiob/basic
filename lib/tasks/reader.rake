namespace :db do
  namespace :reader do
    desc 'Create the read-only role and grant it SELECT on every table'
    task grant: :environment do
      Reader.grant
    end
  end
end

# Grants once the tables exist: Reader's role first, since Omen's task grants to it.
%w[ db:prepare db:reset db:test:prepare ].each do |name|
  Rake::Task[name].enhance do
    %w[ db:reader:grant db:omen:grant ].each do |granted|
      Rake::Task[granted].reenable
      Rake::Task[granted].invoke
    end
  end
end
