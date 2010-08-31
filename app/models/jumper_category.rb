class JumperCategory < CouchRest::ExtendedDocument
  use_database COUCHDB_SERVER
  
  property :name
  property :available

end
