# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_wartrain_session',
  :secret      => 'd7a21737ba57ab161ea15deef9bce82dcb80868d8670f7b4da07441ae686f3193097ae76ea5e5f120257900ce287e450cb1b85921c5c0d5f4c8affd413ec10a9'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
