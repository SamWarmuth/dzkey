class Jumper < CouchRest::ExtendedDocument
  use_database COUCHDB_SERVER
  
  property :name
  property :nickname
  property :password_hash
  
  property :can_view_finances
  property :can_edit_finances
  property :can_view_manifests
  property :can_edit_manifests
  property :can_view_jumpers
  property :can_edit_jumpers
  
  property :street
  property :city
  property :state
  property :zip
  property :country
  
  property :primary_contact, :cast_as => 'Contact'
  property :secondary_contact, :cast_as => 'Contact'
  
  
  
  property :type
  property :is_experienced
  property :licenses #array of Certifications? (USPA, A 47290, ?)
  property :manifest_ids #auto-filled.
  property :balance
  property :available
end

class Contact < Hash
  include CouchRest::CastedModel
  
  property :name
  property :relation
  property :primary_phone
  property :secondary_phone

  property :email
end