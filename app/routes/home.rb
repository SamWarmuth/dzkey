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
  get "/dashboard" do
    haml :dashboard, :layout => false
  end
  get "/manifest" do
    haml :manifest, :layout => false
  end
  
  
  post "/ajax/new-jumper" do
    jumper = Jumper.new
    jumper.name = params[:full_name]
    jumper.nickname = params[:nickname] unless params[:nickname].empty?
    jumper.type = params[:type]
    jumper.balance = params[:balance]
    jumper.save
    return "success"
  end
end
