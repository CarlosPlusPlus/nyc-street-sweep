require_relative 'environment'

require 'sinatra/base'

module NycStreetSweep
  class App < Sinatra::Base

    # View setup for base index page.
    get '/' do
      @main = "Default - Main St"
      @from = "Default - From St"
      @to   = "Default - To St"
      @side = "Default - Side St"

      @regulation_str = "Your regulation will go HERE"
      
      erb :form_test
    end

    # Route for form submission.
    post '/' do
      @main = params[:main_st]
      @from = params[:from_st]
      @to   = params[:to_st]
      @side = params[:side_st]
    
      # Determine regulation based on template values.
      parse_values = Parser.run_parsing(@main,@from,@to,@side)

      @regulation_str = "Street cleaning takes place between #{parse_values[0][0]} and #{parse_values[0][1]}\non #{parse_values[1]}"

      erb :form_test
    end

    # Route for index.erb updates.
    get '/index' do
      erb :index
    end

  end
end