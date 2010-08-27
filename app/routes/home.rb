class Main
  get "/images/favicon.ico" do
    content_type 'ico'
    return ""
  end
  get "/" do
    haml :'public/index', :layout => false
  end
  get "/jumpers" do
    @jumpers = Jumper.all.sort_by{|j| j.last_name}
    haml :jumpers, :layout => false
  end
  get '/manifest' do
    haml :manifest, :layout => false
  end
  get '/schedule' do
    haml :schedule, :layout => false
  end
  get '/checkin' do
    @jumpers = Jumper.all
    haml :checkin, :layout => false
  end
  get '/accounts' do
    haml :accounts, :layout => false
  end
  get '/staff' do
    haml :staff, :layout => false
  end
  get "/aircraft" do 
    haml :aircraft, :layout => false
  end
  get '/manager' do
    haml :manager, :layout => false
  end
  get "/tour" do
    haml :'public/tour', :layout => false
  end
  get "/signup" do
    haml :'public/signup', :layout => false
  end
  get "/contact" do
    haml :'public/contact', :layout => false
  end
  get "/faq" do
    haml :'public/faq', :layout => false
  end
  get "/about" do
    haml :'public/about', :layout => false
  end
  get "/css/style.css" do
    content_type 'text/css', :charset => 'utf-8'
    sass :style
  end
  get "/css/blue.css" do
    content_type 'text/css', :charset => 'utf-8'
    sass :blue
  end
  get "/css/grid.css" do
    content_type 'text/css', :charset => 'utf-8'
    sass :grid
  end
  get "/css/layout.css" do
    content_type 'text/css', :charset => 'utf-8'
    sass :'public/layout'
  end
  get "/app" do
    redirect("/login") unless logged_in?
    @jumpers = Jumper.all.sort_by{|j| j.last_name}
    @current_page = params[:p] || "jumpers"
    @current_version = db_version = COUCHDB_SERVER.info["update_seq"]
    haml :framed, :layout => false
  end
  get "/login" do
    redirect "/app?p=jumpers" if logged_in?
    haml :login, :layout => false
  end
  post "/login" do
    staff = Jumper.all.find{|u| u.email == params[:email].downcase}
    
    if staff && staff.valid_password?(params[:password])
      staff.challenges ||= []
      staff.challenges << (Digest::SHA2.new(512) << (64.times.map{|l|('a'..'z').to_a[rand(25)]}.join)).to_s
      staff.save
      
      response.set_cookie("staff", {
        :path => "/",
        :expires => Time.now + 2**20, #two weeks
        :httponly => true,
        :value => staff.id
      })
      response.set_cookie("staff_challenge", {
        :path => "/",
        :expires => Time.now + 2**20,
        :httponly => true,
        :value => staff.challenges.last
      })
      redirect "/app?p=jumpers"
    else
      redirect "/login" #TODO show an error
    end
  end
  get "/logout" do
    response.set_cookie("staff", {
      :path => "/",
      :expires => Time.now + 2**20,
      :httponly => true,
      :value => ""
    })
    response.set_cookie("staff_challenge", {
      :path => "/",
      :expires => Time.now + 2**20,
      :httponly => true,
      :value => ""
    })
    redirect "/login"
  end
  
  get "/ajax/changes?" do
    db_version = COUCHDB_SERVER.info["update_seq"].to_s
    return (params[:since] == db_version ? "" : db_version)
  end
  
  get "/ajax/edit-jumper" do
    return false unless logged_in?
    return false if params[:id].nil?
    @jumper = Jumper.get(params[:id])
    return false if @jumper.nil?
    haml :edit_jumper, :layout => false
  end
  
  get "/ajax/jumper/available/?" do
    return false unless logged_in?
    return false if (params[:jumper].nil? && params[:jumperID].nil?)
    @jumper = Jumper.get(params[:jumperID]) unless params[:jumperID].nil? || params[:jumperID].empty?
    @jumper = Jumper.all.find{|j| j.name == params[:jumper]} unless params[:jumper].nil? || params[:jumper].empty?
    return false if @jumper.nil?
    if params[:value] == "true"
      return false if @jumper.available
      @jumper.available = true
      @jumper.save
    else
      return false if !@jumper.available
      @jumper.available = false
      @jumper.save
    end
    return @jumper.name + " is now checked in."
  end
  
  
  post "/ajax/jumper/?" do
    return false unless logged_in?
    @jumpers = Jumper.all.sort_by{|j| j.last_name}
    unless params[:id].nil?
      jumper = @jumpers.find{|j| j.id == params[:id]}
      return "Tried to update a jumper that didn't exist (params[:id] != any jumper id)" if jumper.nil?
    else
      jumper = Jumper.new
      jumper.rig_ids = []
    end
    
    jumper.first_name = params[:first_name]
    jumper.first_name = params[:last_name]
    
    jumper.nickname = params[:nickname] unless params[:nickname].empty?
    
    jumper.first_name = params[:first_name]
    jumper.last_name = params[:last_name]
    jumper.address = params[:address]
    jumper.city = params[:city]
    jumper.state = params[:state]
    jumper.country = params[:country]
    
    jumper.type = params[:type]
    jumper.balance = params[:balance].to_f
    jumper.available = (params[:available] == "on")
    jumper.save
    haml :jumpers, :layout => false
  end
  
  get "/ajax/edit-rigs" do
    return false unless logged_in?
    return false if params[:id].nil?
    @jumper = Jumper.get(params[:id])
    return false if @jumper.nil?
    haml :edit_rigs, :layout => false
  end
  
  post "/ajax/rig/?" do
    return "not logged in" unless logged_in?
    return "no jumper id" if params[:jumper_id].nil?
    @jumper = Jumper.get(params[:jumper_id])
    return "jumper is nil" if @jumper.nil?
    rig = Rig.new
    rig.active = true
    rig.name = params[:name]
    rig.container_type = params[:container_type]
    rig.main_type = params[:main_type]
    rig.main_repack = params[:main_repack]
    rig.reserve_type = params[:reserve_type]
    rig.reserve_repack = params[:reserve_repack]
    
    rig.save
    
    @jumper.rig_ids << rig.id
    @jumper.save
    
    @jumpers = Jumper.all.sort_by{|j| j.last_name}
    haml :jumpers, :layout => false
  end
  
  get "/ajax/rig/active/?" do
    return false unless logged_in?
    return false if params[:rigID].nil?
    rig = Rig.get(params[:rigID])
    return false if rig.nil?
    if params[:value] == "true"
      return false if rig.active
      rig.active = true
      rig.save
      return rig.name + " is now active."
    else
      return false unless rig.active
      rig.active = false
      rig.save
      return rig.name + " is no longer active."
    end
  end
  
  
  post "/ajax/staff/?" do
    return false unless logged_in?
    
    unless params[:id].nil?||params[:id].empty?
      staff = Jumper.all.find{|j| j.id == params[:id]}
      return "Tried to update a staff member / jumper that didn't exist (params[:id] != any jumper id)" if staff.nil?
    else
      staff = Jumper.new
      staff.rig_ids = []
      staff.first_name = params[:first_name]
      staff.last_name = params[:last_name]
      staff.address = params[:address]
      staff.city = params[:city]
      staff.state = params[:state]
      staff.country = params[:country]

      staff.nickname = params[:nickname] unless params[:nickname].empty?
    end
    
    staff.is_staff = true
    staff.email = params[:email]
    

    staff.pilot = (params[:pilot]=="on")
    staff.tandem_instructor = (params[:tandem_instructor]=="on")
    staff.aff_instructor = (params[:aff_instructor]=="on")
    staff.videographer = (params[:videographer]=="on")
    
    staff.can_view_jumpers = (params[:can_view_jumpers]=="on")
    staff.can_edit_jumpers = (params[:can_edit_jumpers]=="on")
    
    staff.can_view_manifests = (params[:can_view_manifests]=="on")
    staff.can_edit_manifests = (params[:can_edit_manifests]=="on")
    
    staff.can_view_finances = (params[:can_view_finances]=="on")
    staff.can_edit_finances = (params[:can_edit_finances]=="on")
    
    staff.save
    haml :staff, :layout => false
  end
  
  post "/ajax/staff/permission" do
    return false unless logged_in?
    return false if params[:id].nil? || params[:attribute].nil? || params[:value].nil?
    @staff = Jumper.get(params[:id])
    return "Staffer Not Found." if @staff.nil?
    return false unless @staff.respond_to?(params[:attribute].to_sym)
    @staff[params[:attribute].to_sym] = (params[:value] == "true" ? true : false)
    @staff.save
    return "success"
  end
  
  get "/ajax/edit-aircraft" do
    return false unless logged_in?
    return false if params[:id].nil?
    @aircraft = Aircraft.get(params[:id])
    return false if @aircraft.nil?
    haml :edit_aircraft, :layout => false
  end
  
  post "/ajax/aircraft/?" do
    return false unless logged_in?
    
    unless params[:id].nil?
      aircraft = Aircraft.all.find{|j| j.id == params[:id]}
      return "Tried to update a aircraft that didn't exist (params[:id] != any aircraft id)" if aircraft.nil?
    else
      aircraft = Aircraft.new
    end
    
    aircraft.name = params[:name]
    
    aircraft.flight_prefix = params[:flight_prefix] unless params[:flight_prefix].empty?
    aircraft.cycle_minutes = params[:cycle_minutes] unless params[:cycle_minutes].empty?
    aircraft.type = params[:type]
    aircraft.capacity = params[:capacity] unless params[:capacity].empty?
    aircraft.weight_limit = params[:weight_limit] unless params[:weight_limit].empty?
    
    
    aircraft.available = (params[:available]=="on")
    
    aircraft.save
    haml :aircraft, :layout => false
  end
  
  post "/ajax/transaction/?" do
    return false unless logged_in?
    
    transaction = Transaction.new
    
    transaction.transaction_number = Transaction.count
    transaction.date = Time.now.to_s
    transaction.valid = true
    
    transaction.jumper_id = params[:jumper_id]
    transaction.type = params[:type]
    
    transaction.amount = params[:amount].to_f
    transaction.notes = params[:notes]
    
    transaction.staff_id = @user.id
    transaction.save
    haml :accounts, :layout => false
  end
  
  post "/ajax/void-transaction/?" do
    return false unless logged_in?
    
    transaction = Transaction.all.find{|j| j.id == params[:id]}
    return "Tried to void a transaction that doesn't exist (params[:id] != any transaction id)" if transaction.nil? #debug
    
    transaction.staff_id = @user.id
    
    transaction.available = (params[:available]=="on")
    
    transaction.save
    haml :accounts, :layout => false
  end
  
  post "/ajax/new-flight/?" do
    return false unless logged_in?
    
    aircraft = Aircraft.get(params[:aircraft])
    return false if aircraft.nil?
    
    flight = Flight.new
    flight.aircraft_id = aircraft.id
    flight.aircraft_prefix = aircraft.flight_prefix
    flight.jump_date = Time.now.strftime("%m/%d/%y")
    flight.number = Flight.count
    flight.jumper_ids = []
    flight.cleared = true
    flight.completed = false
    flight.save
    haml :manifest, :layout => false
  end
  
  post "/ajax/add-jumper-to-flight/?" do
    return false unless logged_in?
    return false if params[:jumper].empty? || params[:flight].empty?
    flight = Flight.get(params[:flight])
    return false if flight.nil?
    jumper = Jumper.get(params[:jumper])
    return false if jumper.nil?
    flight.jumper_ids ||= []
    return false if flight.jumper_ids.include?(jumper.id)
    flight.jumper_ids << jumper.id
    flight.save
    return true
  end
  
  post "/ajax/takeoff" do
    return false unless logged_in?
    return false if params[:flight].empty?
    flight = Flight.get(params[:flight])
    flight.completed = true
    flight.save
    Aircraft.get(flight.aircraft_id).reset_flights
    return "success"
  end
  
  post "/ajax/edittakeofftime" do
    return false unless logged_in?
    return false if params[:aircraft].empty?
    return false if params[:time].empty?
    time = params[:time].to_i
    return false if time.nil?
    aircraft = Aircraft.get(params[:aircraft])
    return false if aircraft.departure_time.nil?
    aircraft.departure_time = (Time.parse(aircraft.departure_time) + 60*time).to_s
    aircraft.save
    return "success"
  end
  
  post "/ajax/hold-aircraft" do
    return false unless logged_in?
    return false if params[:aircraft].empty?
    return false if params[:hold].empty?||!["true", "false"].include?(params[:hold])
    aircraft = Aircraft.get(params[:aircraft])
    if params[:hold] == "true"
      aircraft.on_hold = true
    else
      aircraft.on_hold = false
    end
    aircraft.reset_flights
    aircraft.save
    return "success"
  end
end