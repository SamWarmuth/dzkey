class Schedule < CouchRest::ExtendedDocument
  use_database COUCHDB_SERVER
  
  property :name
  property :date
  property :time
  
end