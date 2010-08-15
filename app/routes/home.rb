class Main
  get "/images/favicon.ico" do
    content_type 'ico'
    return ""
  end
  get "/" do
    @big_header = true
    haml :'public/index', :layout => false
  end
  get "/jumpers" do
    haml :jumpers, :layout => false
  end
  get '/manifest' do
    haml :manifest, :layout => false
  end
  get '/schedule' do
    haml :schedule, :layout => false
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
  
  post "/ajax/jumper/?" do
    return false unless logged_in?
    unless params[:id].nil?
      jumper = Jumper.all.find{|j| j.id == params[:id]}
      return "Tried to update a jumper that didn't exist (params[:id] != any jumper id)" if jumper.nil?
    else
      jumper = Jumper.new
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
  
  
  post "/ajax/staff/?" do
    return false unless logged_in?
    
    unless params[:id].nil?
      staff = Jumper.all.find{|j| j.id == params[:id]}
      return "Tried to update a staff member / jumper that didn't exist (params[:id] != any jumper id)" if staff.nil?
    else
      staff = Jumper.new
    end
    
    staff.is_staff = true
    staff.first_name = params[:first_name]
    staff.last_name = params[:last_name]
    staff.address = params[:address]
    staff.city = params[:city]
    staff.state = params[:state]
    staff.country = params[:country]
    
    staff.nickname = params[:nickname] unless params[:nickname].empty?

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
    aircraft.departure_time = (Time.parse(aircraft.departure_time) + 60*time).to_s
    aircraft.save
    return "success"
  end
end