require "sinatra"
require "active_record"
require "rack-flash"
require "gschool_database_connection"
require_relative "lib/users_table"
require_relative "lib/fish_table"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @users_table = UsersTable.new(
      GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
    )
    @fish_table = FishTable.new(
      GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
    )
  end

  get "/" do
    if session[:user_id]
      puts "We still have a session id #{session[:id]}"
    end
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
      if @users_table.find_id_by_name(params[:username]) != nil
        flash[:notice] = "Username is already in use, please choose another."
        redirect "/registration"
      end
      flash[:notice] = "Thank you for registering"
      @users_table.create(params[:username], params[:password])
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
      @fish_table.create(name, wiki, session[:user_id])
      redirect '/'
    end
  end

  get "/friends_fish" do

  end

  post "/login" do
    current_user = @users_table.find_by(params[:username], params[:password])
    if current_user == nil
      flash[:notice] = "Username and password not found!"
    else
      session[:user_id] = current_user["id"]
      flash[:not_logged_in] = true
    end
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
    @users_table.delete(id)
    redirect back
  end

end #end of class
