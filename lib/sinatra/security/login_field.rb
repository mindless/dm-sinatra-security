module Sinatra
  module Security
    # This module allows you to customize the name of the login field used
    # in your datastore. By default :email is used.
    #
    # @example
    #   
    #   # somewhere in your code during bootstrapping
    #   require 'sinatra/security'
    #   Sinatra::Security::LoginField.attr_name :login
    #
    #   # then in your actual user.rb or something...
    #   class User < Ohm::Model
    #     include Sinatra::Security::User
    #     # at this point the following are done:
    #     # attribute :login
    #     # index :login
    #   end
    module LoginField
      EMAIL_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
      # @example
      #   
      #   Sinatra::Security::LoginField.attr_name :username
      #
      #   class User < Ohm::Model
      #     include Sinatra::Security::User
      #     # effectively executes the following:
      #     # attribute :username
      #     # index :username
      #   end
      #
      # @overload attr_name()
      #   Get the value of attr_name.
      # @overload attr_name(attr_name)
      #   @param [#to_sym] attr_name the attr_name to be used e.g. 
      #                    :username, :login.
      # @return [Symbol] the current attr_name.
      def self.attr_name(attr_name = nil)
        @attr_name = attr_name.to_sym if attr_name
        @attr_name
      end
      attr_name :email
      
      def self.included(user)
        if @attr_name == :email
          user.property LoginField.attr_name, String, :unique => true, :required => true, :format => EMAIL_FORMAT
        else
          user.property LoginField.attr_name, String, :unique => true, :required => true
        end
      end
    end
  end
end
