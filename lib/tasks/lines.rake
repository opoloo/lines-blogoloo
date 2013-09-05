namespace :lines do
  
  desc "Setting up database and default entries."
  task :setup => :environment do
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:seed"].invoke
  end

end
