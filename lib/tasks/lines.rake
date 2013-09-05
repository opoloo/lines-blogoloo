namespace :lines do
  
  desc "Setting up database and default entries."
  task :setup => :environment do
    Rake::Task["db:migrate"].invoke
    puts "Migration done.\n\n"
    puts "Importing example articles, author and default user...\n"
    Rake::Task["db:seed"].invoke
    puts "Done."
  end

end
