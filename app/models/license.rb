class License < CouchRest::ExtendedDocument
  use_database COUCHDB_SERVER
  
  property :type
  property :number
end