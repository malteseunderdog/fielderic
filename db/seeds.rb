# author: JP

namespace :db do
  desc "Load seed fixtures (from db/fixtures) into the current environment's database." 
  task :seed => :environment do
    require 'active_record/fixtures'
    
    # this order is important...because of foreign keys
    Fixtures.create_fixtures('db/fixtures', 'player')
    Fixtures.create_fixtures('db/fixtures', 'match')
    Fixtures.create_fixtures('db/fixtures', 'field')
    
  end
end