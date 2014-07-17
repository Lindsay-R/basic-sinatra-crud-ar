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
    # if session[:user_id]
    #   puts "We still have a session id #{session[:id]}"
    # end
    if params[:order_names] == 'asc'
      @user_order = @users_table.select_all_asc
    elsif params[:order_names] == 'desc'
      @user_order = @users_table.select_all_desc
    else
      @user_order = @users_table.select_all
    end
    erb :root
  end

  get '/friend/:index' do
    @friend_id = params[:index].to_i
    erb :friend_fish
  end

  get "/registration" do
    erb :registration
  end

  post "/registration" do
    if params[:username] == '' && params[:password] == ''
      flash[:error_flash] = "Username and password are required"
      redirect "/registration"
    elsif params[:password] == ''
      flash[:error_flash] = "Password is required"
      redirect "/registration"
    elsif params[:username] == ''
      flash[:error_flash] = "Username is required"
      redirect "/registration"
    else
      if @users_table.find_id_by_name(params[:username]) != nil
        flash[:error_flash] = "Username is already in use, please choose another."
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
      flash[:fish_error] = "Fish must have a name!"
      redirect back
    else
      @fish_table.create(name, wiki, session[:user_id])
      redirect '/'
    end
  end

  post "/login" do
    current_user = @users_table.find_by(params[:username], params[:password])
    if params[:username] == '' && params[:password] == ''
      flash[:error_flash] = "Username and password are required"
      redirect back
    elsif params[:password] == ''
      flash[:error_flash] = "Password is required"
      redirect back
    elsif params[:username] == ''
      flash[:error_flash] = "Username is required"
      redirect back
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
