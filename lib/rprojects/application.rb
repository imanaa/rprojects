###############################################################################
# application.rb -- Basic Ruby Application Skeleton with logging features
# Default Arguments of the Skeleton program:
# no-verbose:   Disable logging (This is the default behaviour)
# verbose:    Level of logging (Severity)
# logfile:    The logfile (Default to the script name with .log extension
#
# Copyright (C) 2012  Imad MANAA
# Last Modified : 23/06/2012
# Version : 1.0
###############################################################################

module Rprojects
  # == Description
  # Provides a Skelteon implementation for Ruby Application with logging
  # capabilities.
  #
  # The application name should be set by overriding the appname method
  #
  # Default options can be loaded from from a YAML file in the user's HOME
  # directory. The fileame must have the same name of the script with the
  # .rc.yaml extension.
  #
  # == Usage
  #
  # 1. Define your application class as a sub-class of this class.
  # 2. Override 'appname' method to customize the application name
  # 3. Override 'default_options' and 'parse_options'
  # 4. Override 'run' method in your class to do many things.
  # 5. Lunach the program using 'exit <YOUR_CLASS_NAME>.instance.start'
  #
  # == Example
  #
  #   class HelloWorld < Application
  #     def appname
  #       "HelloWorld !"
  #     end
  #     def default_options
  #       options = { :msg => "Hello World !" }
  #       options.merge! super
  #     end
  #     def parse_options
  #       super
  #       @optparse.on('-m', '--msg=<MSG>', "The message to print") do |msg|
  #         @options[:msg] = msg
  #       end
  #     end
  #     private
  #     def run
  #       puts @options[:msg]
  #       return 0
  #     end
  #   end
  #   if __FILE__ == $0 then
  #     exit HelloWorld.instance.start
  #   end
  #
  class Application < Logger::Application
    include Singleton
    # The object initialization
    def initialize()
      super(self.appname)
      # Parse CLI Options
      @options = default_options
      parse_options
      begin
        @optparse.parse!
      rescue OptionParser::ParseError => e
        STDERR.puts e.message, "\n", @optparse
        exit(1)
      end
      # Initialize Log
      if @options[:verbose].nil? then
        self.logger=Logger.new(nil)
      else
        begin
          self.logger=Logger.new(@options[:logfile], 'daily')
        rescue Errno::ENOENT => e
          STDERR.puts e.message, "***** Using default Logger:Application Settings ******", ""
        end
        self.level=@options[:verbose]
      end
    end

    # Returns the "Application Name"
    def appname
      "Application"
    end

    # Default program options: loof for a file named as the running script with .rc.yaml
    # extension in the user's home directory
    def default_options()
      options = {
        :verbose => nil,
        :logfile => "#{File.basename($0, ".*")}.log"
      }
      config_file = File.join(ENV['HOME'],"#{File.basename($0, ".*")}.rc.yaml")
      if File.exists? config_file then
        config_options = YAML.load_file(config_file)
        options.merge!(config_options)
      end
      return options
    end

    # Parse options relative to logging
    def parse_options
      OptionParser.accept(Logger::Severity,/[0-4]/) do |s|
        case s
        when "0" then Logger::DEBUG
        when "1" then Logger::INFO
        when "2" then Logger::WARN
        when "3" then Logger::ERROR
        when "4" then Logger::FATAL
        else nil
        end
      end
      @optparse = OptionParser.new
      @optparse.banner = "Usage: #{$0} [options]"
      @optparse.define_head "This is a Ruby application"
      @optparse.set_summary_indent("   ")
      @optparse.separator ""
      @optparse.on( '-v', '--verbose=<SEVERITY>','--[no-]verbose', Logger::Severity, '0:FATAL/1:ERROR/2:WARN/3:INFO/4:DEBUG/NONE' ) do |severity|
        @options[:verbose] = (severity==false)? nil : severity
      end
      @optparse.on( '-l', '--logfile=<logfile>', String, 'The name of the log file (verbose!=NONE)' ) do |logfile|
        @options[:logfile] = logfile
      end
      @optparse.on_tail("-h", "--help", "Show this message") do
        STDOUT.puts @optparse
        exit(0)
      end
    end

    private

    # The main code
    def run
      puts "This is : #{app_name}"
      return 0;
    end
  end
end