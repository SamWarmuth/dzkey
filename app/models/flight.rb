class Flight < CouchRest::ExtendedDocument
  use_database COUCHDB_SERVER
  
  property :number
  property :aircraft_prefix
  property :cleared
  
  property :completed
  property :cancelled
  
  property :jump_date
  property :aircraft_id
  
  property :jumper_ids
end