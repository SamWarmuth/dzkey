class Aircraft < CouchRest::ExtendedDocument
  use_database COUCHDB_SERVER
  
  property :name
  property :type
  property :flight_prefix
  property :cycle_minutes
  property :capacity
  property :weight_limit
  property :fuel_level #Track either number of loads until refuel or try to actually track fuel consumption?
  
  property :manifest_ids
  property :available

  property :on_hold
  property :cur_flight
  property :nxt_flight  
  property :departure_time
  
  def current_flight
    return self.cur_flight if self.cur_flight
    flights = Flight.all.find_all{|f| f.aircraft_id == self.id}
    return nil if flights.nil?
    self.cur_flight = flights.sort_by{|f| f.number}.first.id
    self.save
    return self.cur_flight
  end
  def next_flight
    return self.nxt_flight if self.nxt_flight
    self.cur_flight = self.current_flight unless self.cur_flight
    flights = Flight.all.find_all{|f| f.aircraft_id == self.id}
    return nil if flights.nil?
    self.nxt_flight = flights.find_all{|f| f.object_id != self.cur_flight}.sort_by{|f| f.number}.first.id
    return self.nxt_flight
  end
  
end