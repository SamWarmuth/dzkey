class Jumper < CouchRest::ExtendedDocument
  use_database COUCHDB_SERVER
  
  property :name
  property :nickname
  property :password_hash
  
  property :type
  property :certifications #array of Certifications? (USPA, A 47290, ?)
  property :jumps #keep as a hash? {:"june 3 2010" => 4} ?
  property :balance
  property :available
end