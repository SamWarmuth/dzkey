class Plane < CouchRest::ExtendedDocument
  property :name
  property :max_weight
  
  property :jump_ids
  property :available
end