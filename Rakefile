require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require "active_record"
require_relative "lib/text_tagger/data_migration"
require "sqlite3"

RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
end

namespace :text_tagger do
  desc "Create sql data migrations"
  task :migration do
    ttdm = TextTagger::DataMigration.new
    ttdm.generate_sql
  end
end


namespace :db do

  db_config       = YAML::load(File.open('config/database.yml'))['development']

  desc "Create the database"
  task :create do
    ActiveRecord::Base.establish_connection(db_config)
    ActiveRecord::Base.connection.create_database(db_config["database"])
    puts "Database created."
  end

  desc "Migrate the database"
  task :migrate do
    ActiveRecord::Base.establish_connection(db_config)
    ActiveRecord::Migrator.migrate("db/migrate/")
    Rake::Task["db:schema"].invoke
    puts "Database migrated."
  end

  desc "Drop the database"
  task :drop do
    ActiveRecord::Base.establish_connection(db_config)
    ActiveRecord::Base.connection.drop_database(db_config["database"])
    puts "Database deleted."
  end

  desc "Reset the database"
  task :reset => [:drop, :create, :migrate]

end


task :spec => :build
task :default => :spec