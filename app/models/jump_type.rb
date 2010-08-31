class JumpType < CouchRest::ExtendedDocument
  use_database COUCHDB_SERVER
  
  property :available
  
  property :name
  property :cost
  
  property :tandem_required
  property :coach_required
  property :videographer_required
  
  property :jumper_category_ids
end
