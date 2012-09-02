# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

## NOTE: setting the Id of each model here is useless as this is ignored...
##       Hence the resetting the pks of each table.  Alternatively keep track
##       of what is being created and m = Match.create(...) and use m.id.  (Too
##       much work).  JP

## WARNING:  Any existing data in the tables will be reset!!

# ******************
# **   Matches   ***
# ******************

Match.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('match')

Match.create(created: '2012-01-05 18:00:00',
             kickoff: '2012-06-06 11:00:00',
             location: 'Qormi, Malta',
             variety: '5-a-side',
             required: 8,
             comment: 'Only reliable people please')

Match.create(created: '2012-01-10 17:00:31',
             kickoff: '2012-07-16 12:00:00',
             location: 'Oxford, UK',
             variety: '11-a-side',
             required: 3)

Match.create(created: '2012-01-12 18:35:45',
             kickoff: '2012-08-30 18:55:00',
             location: 'St. Martins, Malta',
             variety: '5-a-side',
             required: 2,
             comment: 'Need a couple of goalkeepers')

Match.create(created: '2012-01-16 16:55:21',
             kickoff: '2012-08-30 18:55:00',
             location: 'Cambridge, UK',
             variety: '5-a-side',
             required: 4)

Match.create(created: '2012-01-01 10:34:12',
             kickoff: '2012-03-02 11:30:00',
             location: 'Mosta, Malta',
             variety: '6-a-side',
             required: 5,
             comment: 'Only interested in good players')

Match.create(created: '2012-01-01 10:34:12',
             kickoff: '2012-01-02 12:12:12',
             location: 'Narnia',
             variety: '12-a-side',
             required: 5,
             comment: 'IN THE PAST SHOULD NOT APPEAR')


# ******************
# **   Players   ***
# ******************

Player.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('player')

Player.create(name: 'Jean-Paul Ebejer',
              nickname: 'l-artist' ,
              email: 'jp@fielderic.com',
              mobile: '79123456',
              password: Digest::SHA2.hexdigest("1" + "test123"),
              location: 'Oxford,United Kingdom')

Player.create(name: 'David Camilleri',
              nickname: 'dave' ,
              email: 'dave@fielderic.com',
              mobile: '+44 75 6447 2800',
              password: Digest::SHA2.hexdigest("2" + "test123"),
              location: 'London, United Kingdom')

Player.create(name: 'Michael Camilleri',
              nickname: 'mikey',
              email: 'mike@fielderic.com',
              mobile: '00447512345678',
              password: Digest::SHA2.hexdigest("3" + "test123"),
              location: 'London, United Kingdom')

Player.create(name: 'Eric Cantona',
              nickname: 'eric', 
              email: 'eric@fielderic.com',
              mobile: '+77 77 77 77 77 77',
              password: Digest::SHA2.hexdigest("4" + "test123"),
              location: 'Malta')

# *****************
# **   Fields   ***
# *****************

Field.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('field')

Field.create(player_id: 1,
             match_id: 1,
             organiser: TRUE,
             joined: '2012-01-05 19:00:00')

Field.create(player_id: 2,
             match_id: 1,
             organiser: FALSE,
             joined: '2012-01-08 19:11:39')
    
Field.create(player_id: 3,
             match_id: 1,
             organiser: FALSE,
             joined: '2012-01-11 10:01:23')
    
Field.create(player_id: 3,
             match_id: 3,
             organiser: TRUE,
             joined: '2012-01-12 19:11:26')

Field.create(player_id: 3,
             match_id: 4,
             organiser: FALSE,
             joined: '2012-01-14 15:09:01')
    
Field.create(player_id: 2,
             match_id: 5,
             organiser: TRUE,
             joined: '2012-01-16 13:45:50')

