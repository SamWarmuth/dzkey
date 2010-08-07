class Aircraft < CouchRest::ExtendedDocument
  use_database COUCHDB_SERVER
  
  property :name
  property :type
  property :flight_prefix
  property :cycle_minutes
  property :capacity
  property :weight_limit
  property :fuel_level #Track either number of loads until refuel or try to actually track fuel consumption?
  
  property :manifest_ids
  property :available
  property :hold
end