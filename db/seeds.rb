# encoding: utf-8

Author.create([
  { :name => "Opoloo Squirrel", :email => "squirrel@opoloo.de", :created_at => "2012-12-12 12:12:12", :updated_at => "2012-12-12 12:12:12", :description => "Squirrels are sooooo cute", :gplus_profile => "https://plus.google.com/squirrel" }
], :without_protection => true )

User.create([
 { email: "squirrel@example.org", password: "ultrasekret" }
])

Article.create([
  { :title => "Congratulations! You Have a Lines Blog", :sub_title => "Read up on what you get with this blog", :content => "This blog is designed to put the reading experience first. The viewer scales perfectly to all screen sizes and devices. So no frustration for the reader caused by small illegible text, no tiny clickable items, but full focus on content instead. \r\n\r\n#Technology\r\n\r\nThis blog is based on the latest Ruby 3.2, which is all you need besides a database that supports it. We're using a MySQL database. We're providing as clean a code as possible, and of course we'll maintain it and keep it up-to-date on GitHub.\r\n\r\n#Default features\r\n+ 960x540 px hero graphics for posts\r\n+ upload default hero images that you want to use more frequently\r\n+ customizable generic titles & subtitles\r\n+ automatic teaser for the article overview\r\n+ six headline styles according to priority\r\n+ *italics* & **bold text**\r\n+ > block quotes\r\n\r\n+ images, lists, links\r\n+ code examples in markdown\r\n```javascript\r\nfunction fancyAlert(arg) {\r\n  if(arg) {\r\n    $.facebox({div:'#foo'})\r\n  }\r\n}\r\n```\r\n+ tags for articles\r\n+ G+ link to social network discussion\r\n+ multiple authors and author information\r\n+ add documents for download\r\n+ formatting help\r\n+ direct RSS reader access\r\n+ customizable footer\r\n\r\nBy default, the featured post (usually the latest one) is fully displayed, but you may choose your featured post. Below that, the user finds an overview of all the articles published with a small hero graphic and a teaser. If you have more than ten articles in your overview, pagination kicks in. \r\n\r\n#Non-Features\r\n+ management hassle\r\n+ rights and legal bullshit\r\n+ complicated settings\r\n+ disco lights\r\n\r\n\r\n#Design\r\n###Fonts: \r\nHeadlines for posts and H1.s are set in \"Museo\", the rest is \"Ubuntu\" — clean, future-oriented, democratic, appealing.\r\n# So, an H1 headline would look like this\r\n## Whereas, an H2 looks like this\r\n###And so on\r\n####And so forth\r\n#####Until, finally\r\n######You come to an H6. \r\n######Sometimes, it's nice to use those headline tags for highlighting continuing text, too, or for footnotes, additional comments, whatever you can imagine.\r\n\r\n###Colors: \r\nOpoloo orange and shades of grey\r\n\r\n###Flat: \r\nOur Android background clearly shows in the completely flat design approach. No drop shadows, no gloss, no distractions.\r\n\r\n#For Developers\r\nNearly everything about this blog template can be customized to your personal needs and preferences. If you're only the tiniest bit tech-savvy, you have almost all the possibilities in the world with this blog. \r\n\r\n#Frontend\r\nJust to be clear: frontend is the visual representation of the backend — everything you actually see when you're editing, curating, and managing your blog posts. \r\nThe frontend has received considerable Opoloo love and is designed to work simply and beautifully, from action bar to usability issues, so you can use your time thinking about your content, instead of puzzling where to click next.\r\n\r\n#Manage Articles\r\n![Alt text](/uploads/picture/image/141/SC1.png)\r\n\r\n#Edit Articles\r\n![Alt text](/uploads/picture/image/142/SC2.png)\r\n\r\n#Preview \r\n![Alt text](/uploads/picture/image/143/SC3.png)\r\n\r\n\r\nYou'll be able to find everything you need on [GitHub](https://github.com/opoloo/lines).\r\n", :published => true, :published_at => "2013-09-05 00:00:00", :hero_image => "", :created_at => "2013-09-05 07:35:34", :updated_at => "2013-09-05 07:38:19", :slug => "congratulations-you-have-a-lines-blog", :gplus_url => "", :featured => true, :document => nil, :short_hero_image => "/heroes/001_dark.jpg", :authors => [Author.first] },
  { :title => "Readme: Installation, Important facts, Minimal Developer Documentation", :sub_title => "", :content => "Readme: Installation, Important facts, Minimal Developer Documentation", :published => true, :published_at => "2013-09-05 00:00:00", :hero_image => nil, :created_at => "2013-09-05 07:39:02", :updated_at => "2013-09-05 07:39:10", :slug => "readme-installation-important-facts-minimal-developer-documentation", :gplus_url => "", :featured => false, :document => nil, :short_hero_image => "/heroes/001_dark.jpg", :authors => [Author.first] },
  { :title => "Documentation for Lines", :sub_title => "", :content => "Where to find all the important stuff", :published => true, :published_at => "2013-09-05 00:00:00", :hero_image => nil, :created_at => "2013-09-05 07:39:43", :updated_at => "2013-09-05 07:39:45", :slug => "documentation-for-lines", :gplus_url => "", :featured => false, :document => nil, :short_hero_image => "/heroes/003.jpg", :authors => [Author.first] }
], :without_protection => true )


