require 'last_line'
require 'rails'

module LastLine
  class Railtie < ::Rails::Railtie
    initializer "last_line.action_controller" do |app|
      ActiveSupport.on_load :action_controller do
        ActionController::Base.send :include, Controller
      end
    end
  end
end