require "sinatra"
require "active_record"
require "rack-flash"
require "./lib/database_connection"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash
  def initialize
    super
    @database_connection = DatabaseConnection.new(ENV["RACK_ENV"])
  end

  get "/" do
  erb :root
  end

  get "/registration" do
    erb :registration
  end

  post "/registration" do
    flash[:notice] = "Thank you for registering"
    redirect "/"
  end

  post "/login" do
    flash[:not_logged_in] = true
    redirect "/"
  end
end #end of class
