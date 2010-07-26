class Jumper < CouchRest::ExtendedDocument
  use_database COUCHDB_SERVER
  property :available
  
  property :first_name
  property :last_name
  
  def name
    return self.first_name.to_s + " " + self.last_name.to_s
  end
  property :nickname
  
  property :weight
  property :rig_ids
  
  property :address
  property :city
  property :state
  property :zip
  property :country
  
  property :primary_contact, :cast_as => 'Contact'
  property :secondary_contact, :cast_as => 'Contact'
  
  
  property :type #just student/not student? everything else is in the next couple props.
  
  property :is_experienced
  property :licenses #array of Certifications? (USPA, A 47290, ?)
  property :manifest_ids #auto-filled from manifests.
  
  property :balance
  
  #member properties
  property :password_hash
  property :logins #array of dates (e.g. ["7/9/11 3:00PM", "7/10/11 2:35PM"]) For usage logs
  

  property :is_staff
  
  #instructor Properties
  property :pilot
  property :tandem_instructor
  property :videographer
  property :aff_instructor
  
  #staff properties
  property :can_view_finances
  property :can_edit_finances
  property :can_view_manifests
  property :can_edit_manifests
  property :can_view_jumpers
  property :can_edit_jumpers
  
end

class Contact < Hash
  include CouchRest::CastedModel
  
  property :name
  property :relation
  property :primary_phone
  property :secondary_phone

  property :email
end