# Require environment.rb 

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

    post '/' do

      @main = params[:main_st]
      @from = params[:from_st]
      @to   = params[:to_st]
      @side = params[:side_st]
      
      ######################
      # OUR CODE GOES HERE #
      ######################

      # Geocoder -> Main St + Cross St 1
      #          -> Main St + Cross St 2

      #       Returns Array of [Lat,Long]

      # Call Geocoder.rb to generate (x1,y1) to (x2,y2) lat/long.

      @regulation_str = "POSTED SOURCE"

      erb :form_test
    end

  end
end