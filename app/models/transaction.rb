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
  
  save_callback :after, :update_jumper_balance
  
  def update_jumper_balance
    return false if self.jumper_id.nil?
    jumper = Jumper.get(self.jumper_id);
    jumper.balance = Transaction.all.find_all{|t| t.jumper_id == jumper.id}.inject(0){|balance, j| balance + j.amount}
    jumper.save
  end
end
