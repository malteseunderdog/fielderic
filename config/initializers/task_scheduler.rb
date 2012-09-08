# This script is responsible for scheculed tasks.  Note that most work should be
# delegated to the proper controller/library rather than in here

require 'rubygems'
require 'rufus/scheduler'

scheduler = Rufus::Scheduler.start_new

scheduler.every '40m' do
  PlayersController.notify_about_match()
end