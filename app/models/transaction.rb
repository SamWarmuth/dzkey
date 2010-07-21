class Transaction < CouchRest::ExtendedDocument
  use_database COUCHDB_SERVER
  
  property :type
  property :date
  
  property :jumper_id
  property :user_id
  property :amount
end