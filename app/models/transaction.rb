class Transaction < CouchRest::ExtendedDocument
  use_database COUCHDB_SERVER
  
  property :type
  property :date
  
  property :jumper_id
  property :receiving_jumper #if it's a transfer to another account. Come up with a better name.
  property :user_id #staff that created the transaction
  property :amount
end