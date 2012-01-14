# author: JP
# copied from: http://quotedprintable.com/2007/11/16/seed-data-in-rails

namespace :db do
  desc "Load seed fixtures (from db/fixtures) into the current environment's database." 
  task :seed => :environment do
    require 'active_record/fixtures'
    
    # this order is important...
    Fixtures.create_fixtures('db/fixtures', 'player')
    Fixtures.create_fixtures('db/fixtures', 'match')
    Fixtures.create_fixtures('db/fixtures', 'field')
    
    # Dir.glob(RAILS_ROOT + '/db/fixtures/*.yml').each do |file|
      # # show some silly message
      # puts "Loading fixture ... " + file 
      # # load them
      # Fixtures.create_fixtures('db/fixtures', File.basename(file, '.*'))
    # end
  end
end