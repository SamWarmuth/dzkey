class Plane < CouchRest::ExtendedDocument
  property :name
  property :type
  property :flight_prefix
  property :cycle_minutes
  property :capacity
  
  property :manifest_ids
  property :available
end