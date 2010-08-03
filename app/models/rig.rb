class Rig < CouchRest::ExtendedDocument
  use_database COUCHDB_SERVER
  
  property :name
  property :id
  property :container_type
  property :reserve_type
  property :main_type
  
  property :last_main_repack #or next needed? Are all packs the same?
  property :last_reserve_repack #or next needed.
end