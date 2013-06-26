require_relative 'environment'

require 'sinatra/base'

module NycStreetSweep
  class App < Sinatra::Base

    get '/' do      
      # Define all variables for template.
      map_gen   = false

      @main  = ""
      @from  = ""
      @to    = ""
      @side  = ""
      @text  = "optional"
      @tweet = "optional"

      @map_javascript = MapGenerator.generate_js(map_gen)

      @regulation_str = "THE STREET SWEEPING DATES AND TIMES WILL APPEAR HERE"
      
      erb :index
    end

    post '/' do
      # Define all variables for template.
      map_gen   = true

      @main  = params[:main_st]
      @from  = params[:from_st]
      @to    = params[:to_st]
      @side  = params[:side_st]
      @text  = params[:text]
      @tweet = params[:tweet]

      @map_javascript = MapGenerator.generate_js(map_gen,@main,@from,@to)
    
      # Determine regulation based on template values.
      
      parse_values = Parser.run_parsing(@main,@from,@to,@side)
      
      days_of_week = ""

      parse_values[1].each do |x|
        if parse_values[1].length == 2
          if x == parse_values[1].last
            days_of_week << " and #{x}."
          else
            days_of_week << "#{x} "
          end
        else
          if x == parse_values[1].last
            days_of_week << " and #{x}."
          else
            days_of_week << "#{x}, "
          end
        end
      end

      @regulation_str = "Street cleaning takes place between #{parse_values[0][0].strftime("%k:%M%p")} and #{parse_values[0][1].strftime("%k:%M%p")}\non #{days_of_week}"

      # Text and Tweet regulation info.
      msg = "Please move your car by #{parse_values[0][0].strftime("%k:%M%p")}! #NYCStreetSweep"

      Text.send(@text,msg) if @text.length > 0 && @text != "optional"
      
      Tweet.send(@tweet,msg) if @tweet.length > 0 && @tweet != "optional"

      erb :index
    end

    # Route for index.erb updates.
    get '/test' do

      @main  = "Default - Main St"
      @from  = "Default - From St"
      @to    = "Default - To St"
      @side  = "Default - Side St"
      @text  = "Default - Text"
      @tweet = "Default - Tweet"

      @regulation_str = "Your regulation will go HERE"

      erb :test
    end

  end
end