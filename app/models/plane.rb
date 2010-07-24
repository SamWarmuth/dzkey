class Plane < CouchRest::ExtendedDocument
  property :name
  property :type
  property :flight_prefix #nickname?
  property :cycle_minutes
  property :capacity #Passengers. Do we want weight as well?
  
  property :manifest_ids
  property :available
end