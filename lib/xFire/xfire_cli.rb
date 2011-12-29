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
      Xque::Setup.build(app_name)
    end

    desc "register", "Register your Xque app with MarkLogic. You must be in your Xque app directory"
    def register
      yaml_location = File.join(Dir::pwd,'xque.yml')
      if (File.exists?(yaml_location))
        xque_config = YAML::load( File.open(yaml_location))['development']
        session = Xcc::Session.new(xque_config['user'], xque_config['password'], "localhost", 'Documents', xque_config['marklogic_port'])
        
        session = Xcc::Session.new(xque_config['user'], xque_config['password'], "localhost", xque_config["database"], xque_config['marklogic_port'])
        if  session.query("admin:http-server-create(admin:get-configuration())")
          session.query("admin:http-server-create(admin:get-configuration(), admin:group-get-id(admin:get-configuration(), '#{xque_config['group'] || 'Default'}', #{File.split(Dir::pwd)[1]}
          #{File.join(Dir::pwd,'app','')}, #{}, 0, xdmp:database('#{xque_config['database']}') ))")
        end
      end
    end
  end
end
Xfire::CLI.start