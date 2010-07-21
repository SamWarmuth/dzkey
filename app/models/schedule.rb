class Jumper < CouchRest::ExtendedDocument
  use_database COUCHDB_SERVER
  
  property :jumper_id
  property :date
  property :time
  
  property :manifest_id
end