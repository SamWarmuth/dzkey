class License < CouchRest::ExtendedDocument
  use_database COUCHDB_SERVER
  
  property :type
  property :number
  property :expiration_date

end
