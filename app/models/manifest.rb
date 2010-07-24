class Manifest < CouchRest::ExtendedDocument
  use_database COUCHDB_SERVER
  
  property :jump_date
  property :plane_id
  property :flight_number
  
  property :jump_type
  property :jumper_ids
end