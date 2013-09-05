namespace :lines do
  
  desc "Setting up database and default entries."
  task :setup => :environment do
    
    # Run migrations
    Rake::Task["db:migrate"].invoke
    puts "Migration done.\n\n"
    
    # Seed default db entries
    if Article.count == 0 || Author.count == 0
      puts "Importing example articlesand author...\n"
      Rake::Task["db:seed"].invoke
      puts "Done."
    end
    
    # Get user's credentials
    puts "\n\nLets create a user for administration. This step is required to be able to login.\n\n"
    get_credentials
    
    # Validate and create user
    u = User.new(email: @emailaddr, password: @pw)
    if u.valid? && u.save!
      puts "\n\nUser created. Now head to #{CONFIG[:host]}/admin to get started."
    else
      puts "Something went wrong. lets do it again...\n"
      get_credentials
    end
  end


  # Reads credentials(email and password) from STDIN
  def get_credentials
    print "Your Emailaddress: "
    @emailaddr = STDIN.gets.strip.to_s
    print "Choose a password: "
    @pw = STDIN.gets.strip.to_s
    get_credentials if commit_credentials == false
  end

  def commit_credentials
    print "\n\nAre the above values correct? (y/n) "
    if STDIN.gets.strip.to_s == "n"
      return false
    end
    true
  end

end
