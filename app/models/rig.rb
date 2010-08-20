class Rig < CouchRest::ExtendedDocument
  use_database COUCHDB_SERVER
  
  property :name
  property :active
  
  property :jumper_ids
  property :container_type
  property :reserve_type
  property :main_type
  
  property :main_repack
  property :reserve_repack 
end