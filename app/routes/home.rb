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
    haml :framed, :layout => false
  end
  get "/login" do
    haml :login, :layout => false
  end
  get "/dashboard" do
    haml :dashboard, :layout => false
  end
  get "/manifest" do
    haml :manifest, :layout => false
  end
    
end
