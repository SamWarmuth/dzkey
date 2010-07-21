class User < CouchRest::ExtendedDocument
  use_database COUCHDB_SERVER
  
  property :name
  property :password_hash
  
  property :can_view_finances
  property :can_edit_finances
  property :can_view_manifests
  property :can_edit_manifests
  property :can_view_members
  property :can_edit_members
  
  property :available
end