class Transaction < CouchRest::ExtendedDocument
  use_database COUCHDB_SERVER
  
  property :jumper_id
  property :type #credit/debit
  property :amount
  
  property :date
  
  property :staff_id
end