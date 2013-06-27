require_relative 'environment'

require 'sinatra/base'

module NycStreetSweep
  class App < Sinatra::Base

    # Route => Default view at index page.
    get '/' do      
      
      # Define all variables for template.
      map_gen   = false

      @main  = ""
      @from  = ""
      @to    = ""
      @side  = ""
      @text  = "optional"
      @tweet = "optional"

      # Setup regulation string for web page print.
      @regulation_str = "PLEASE ENTER ADDRESS INFORMATION TO SEE MATCHING REGULATION."

      # Generate Javascript to be used in template for map display.
      @map_javascript = MapGenerator.generate_js(map_gen)
      
      erb :index
    end

    # Route => View seen when form is submitted.
    post '/' do
      
      # Define all variables for template.
      map_gen   = true

      @main  = params[:main_st]
      @from  = params[:from_st]
      @to    = params[:to_st]
      @side  = params[:side_st]
      @text  = params[:text]
      @tweet = params[:tweet]
    
      # Determine regulation based on template values.
      parse_values = Parser.parse_info(@main,@from,@to,@side)
      
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

      # Setup regulation string for web page print.
      @regulation_str = "Street cleaning takes place between #{parse_values[0][0].strftime("%k:%M%p")} and #{parse_values[0][1].strftime("%k:%M%p")}\non #{days_of_week}"

      # Generate Javascript to be used in template for map display.
      @map_javascript = MapGenerator.generate_js(map_gen,@main,@from,@to)

      # Text and Tweet regulation info.
      msg = "Please move your car by #{parse_values[0][0].strftime("%k:%M%p")}! #NYCStreetSweep"

      Text.send(@text,msg)   if @text.length  > 0 && @text  != "optional"
      Tweet.send(@tweet,msg) if @tweet.length > 0 && @tweet != "optional"

      erb :index
    
    end

  end
end