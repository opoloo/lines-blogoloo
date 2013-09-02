# encoding: utf-8

Author.create([
  { :name => "Opoloo Squirrel", :email => "squirrel@opoloo.de", :created_at => "2012-12-12 12:12:12", :updated_at => "2012-12-12 12:12:12", :description => "Squirrels are sooooo cute", :gplus_profile => "https://plus.google.com/squirrel" }
], :without_protection => true )

User.create([
 { email: "squirrel@example.org", password: "ultrasekret" }
])
