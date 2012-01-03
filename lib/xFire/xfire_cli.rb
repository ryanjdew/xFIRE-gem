#!/usr/bin/ruby
require 'rubygems'
require 'xcc'
require 'fileutils'
require 'xFire/xfire_setup'
require 'thor'

module Xfire
  class CLI < Thor
    desc "new [APP_NAME]", "create your XQuery App"
    def new(app_name)
      Xfire::Setup.build(app_name)
    end

    desc "register", "Register your xFire app with MarkLogic. You must be in your xFire app directory"
    def register
      yaml_location = File.join(Dir::pwd,'xfire.yml')
      if (File.exists?(yaml_location))
        xfire_config = YAML::load( File.open(yaml_location))['development']        
        session = Xcc::Session.new(xfire_config['user'], xfire_config['password'], "localhost", xfire_config["database"], xfire_config['marklogic_port'])
        if  session.query("admin:http-server-create(admin:get-configuration())")
          session.query("admin:http-server-create(admin:get-configuration(), admin:group-get-id(admin:get-configuration(), '#{xfire_config['group'] || 'Default'}', #{File.split(Dir::pwd)[1]}
          #{File.join(Dir::pwd,'app','')}, #{}, 0, xdmp:database('#{xfire_config['database']}') ))")
        end
      end
    end
  end
end
Xfire::CLI.start