class Transaction < CouchRest::ExtendedDocument
  use_database COUCHDB_SERVER
  
  property :transaction_number
  property :date
  property :valid
  
  property :jumper_id
  property :type #credit/debit
  property :amount
  property :notes
  
  property :staff_id
end