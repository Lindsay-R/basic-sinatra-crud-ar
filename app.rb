require "sinatra"
require "active_record"
require "rack-flash"
require "gschool_database_connection"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])

  end

  get "/" do
    if session[:user_id]
      puts "We still have a session id #{session[:id]}"
    end
    if params[:order_names] == "asc"
      @suffix = " ORDER BY username ASC"
    elsif params[:order_names] == "desc"
      @suffix = " ORDER BY username DESC"
    end
    @other_users = "SELECT username,id FROM users"
    erb :root
  end

  get "/registration" do
    erb :registration
  end

  post "/registration" do
    if params[:username] == '' && params[:password] == ''
      flash[:notice] = "Please fill in username and password"
      redirect "/registration"
    elsif params[:password] == ''
      flash[:notice] = "Please fill in password"
      redirect "/registration"
    elsif params[:username] == ''
      flash[:notice] = "Please fill in username"
      redirect "/registration"
    else
      if @database_connection.sql("SELECT id FROM users WHERE username = '#{params[:username]}'") != []
        flash[:notice] = "Username is already in use, please choose another."
        redirect "/registration"
      end
      flash[:notice] = "Thank you for registering"
      @database_connection.sql("INSERT INTO users (username, password) VALUES ('#{params[:username]}', '#{params[:password]}')")
      redirect "/"
    end
  end

  post "/fish" do
    name = params[:name]
    wiki = params[:wiki]
    if name == ""
      flash[:notice] = "Fish must have a name!"
      redirect back
    else
      @database_connection.sql("INSERT INTO fish (fish_name, fish_wiki, user_id) VALUES ('#{name}', '#{wiki}', #{session[:user_id]})")
      redirect '/'
    end
  end

  get "/friends_fish" do

  end

  post "/login" do
    current_user = @database_connection.sql("SELECT * FROM users WHERE username='#{params[:username]}' AND password='#{params[:password]}';").first
    puts "user is #{current_user["username"]}"
    session[:user_id] = current_user["id"]
    # p "the session id is #{session[:user_id]}"
    flash[:not_logged_in] = true
    redirect "/"
  end

  post "/logout" do
    session[:user_id] = nil
    redirect "/"
  end

  get '/fish' do
    erb :fish
  end

  get '/delete_user/:index' do
    id = params[:index].to_i
    @database_connection.sql("DELETE FROM users where id = #{id}")
    redirect back
  end

end #end of class
