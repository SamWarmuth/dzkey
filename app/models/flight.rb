class Flight < CouchRest::ExtendedDocument
  use_database COUCHDB_SERVER
  
  property :number
  property :aircraft_prefix
  property :cancelled
  
  property :cleared
  property :taken_off
  property :landed
  
  property :jump_date
  property :aircraft_id
  
  property :jumper_ids
end