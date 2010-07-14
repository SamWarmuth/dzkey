class Jumper < CouchRest::ExtendedDocument
  use_database COUCHDB_SERVER
  
  property :name
  property :nickname
  property :total_jumps #keep as a hash? {:"june 3 2010" => 4} ?
  property :balance
  property :available
end