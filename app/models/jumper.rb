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
  
  
  property :type
  
  property :is_experienced
  property :licenses #array of Certifications? (USPA, A 47290, ?)
  
  property :man_ids
  
  def manifest_ids
    return self.man_ids if self.man_ids
    self.man_ids = Flight.all.find_all{|f| f.jumper_ids.include?(self.id)}
    self.save
    return self.man_ids
  end
  
  property :balance
  
  def set_password(password)
    self.salt = 64.times.map{|l|('a'..'z').to_a[rand(25)]}.join
    self.password_hash = (Digest::SHA2.new(512) << (self.salt + password + "rofosggnxrrwwiwk")).to_s
  end
  def valid_password?(password)
    return false if (self.password_hash.nil? || self.salt.nil?)
    return ((Digest::SHA2.new(512) << (self.salt + password + "rofosggnxrrwwiwk")).to_s == password_hash)
  end
  #member properties
  property :email
  property :password_hash
  property :salt
  property :challenges #array of challeneges....really shouldn't keep these forever.
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