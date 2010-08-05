class Main
  get "/" do
    @big_header = true
    haml :'public/home', :layout => :public
  end
  get "/about" do
    haml :'public/about', :layout => :public
  end
  get "/pricing" do
    haml :'public/pricing', :layout => false
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
  get "/index" do
    @current_page = params[:p] || "dashboard"
    haml :framed, :layout => false
  end
  get "/login" do
    haml :login, :layout => false
  end
  post "/login" do
    #verify user
    redirect "/index?p=jumpers"
  end
  get "/manager" do
    haml :manager, :layout => false
  end
  get "/manifest" do
    haml :manifest, :layout => false
  end
  
  post "/ajax/jumper/?" do
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
    transaction = Transaction.new
    
    transaction.transaction_number = Transaction.count
    transaction.date = Time.now.to_s
    transaction.valid = true
    
    transaction.jumper_id = params[:jumper_id]
    transaction.type = params[:type]
    
    transaction.amount = params[:amount].to_f
    transaction.notes = params[:notes]
    
    #transaction.staff_id = @current_user.id
    transaction.save
    haml :accounts, :layout => false
  end
  
  post "/ajax/void-transaction/?" do
    transaction = Transaction.all.find{|j| j.id == params[:id]}
    return "Tried to void a transaction that doesn't exist (params[:id] != any transaction id)" if transaction.nil?
    
    transaction.staff_id = @current_user.id
    
    
    transaction.available = (params[:available]=="on")
    
    transaction.save
    haml :accounts, :layout => false
  end
end
