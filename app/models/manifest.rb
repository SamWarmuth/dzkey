class Manifest < CouchRest::ExtendedDocument
  use_database COUCHDB_SERVER
  
  property :jump_date
  property :plane_id
  
  property :jump_type
  property :jumper_ids
end