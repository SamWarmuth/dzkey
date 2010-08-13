class Flight < CouchRest::ExtendedDocument
  use_database COUCHDB_SERVER
  
  property :number
  property :taken_off
  property :landed
  
  property :jump_date
  property :aircraft_id
  
  property :jump_type
  property :jumper_ids
end