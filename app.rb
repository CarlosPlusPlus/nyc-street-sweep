# Require environment.rb 

require 'sinatra/base'

module NycStreetSweep
  class App < Sinatra::Base

    # View setup for base index page.
    get '/' do
      erb :form_test
    end
  
  end
end