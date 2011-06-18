# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_fielderic_session',
  :secret      => 'f46c6f024ef1464d25c5585591fbe4197a639035784ba0fb9884418b9c9ebc34ef5960b3ff1047a8fae369637258ea6fa3006ddf71d273451e95ae776a0d535a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
