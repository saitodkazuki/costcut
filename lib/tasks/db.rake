namespace :db do
  desc "drop, create, migrate, seed"
  task build: :environment do
    Rake::Task["db:drop"].invoke rescue nil
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:seed"].invoke
  end
end
