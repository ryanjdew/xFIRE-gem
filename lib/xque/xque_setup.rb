require 'fileutils'
require 'erubis'
module Xque
  module Setup
    def self.build(app_name)
      directory_name = File.join(Dir::pwd,app_name)
      if Dir.exists?(directory_name)
        puts "Sorry, folder already exists"
      else        
        FileUtils.cp_r "#{File.dirname(__FILE__)}/template/application", directory_name
        input = File.read("#{File.dirname(__FILE__)}/template/config/xque.yml")
        eruby = Erubis::Eruby.new(input)    # create Eruby object

        print "Enter Username [admin]:"
        username = STDIN.gets.chomp
        username = (username == '') ? 'admin' : username

        print "Enter Password [admin]:"
        password = STDIN.gets.chomp
        password = (password == '') ? 'admin' : password

        print "Enter XCC Port [Default Port]:"
        marklogic_port = STDIN.gets.chomp 
        marklogic_port = (marklogic_port == '') ? '-1' : marklogic_port

        print "Enter Group [Default]:"
        group = STDIN.gets.chomp 
        group = (group == '') ? 'Default' : group

        print "Enter App Server Port [8005]:"
        app_port = STDIN.gets.chomp 
        app_port = (app_port == '') ? '8005' : app_port

        print "Enter Database [#{app_name}_DB]:"
        database = STDIN.gets.chomp 
        database = (database == '') ? "#{app_name}_DB" : database

        print "Enter Forest [#{app_name}_FRST]:"
        forest = STDIN.gets.chomp 
        forest = (forest == '') ? "#{app_name}_FRST" : forest

        File.open(File.join(directory_name,'xque.yml'), 'w') {|f| f.write(eruby.result(binding())) }
      end
    end
  end
end