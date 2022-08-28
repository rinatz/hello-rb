#!/usr/bin/env ruby
# frozen_string_literal: true

require 'logger'
require 'optparse'

VERSION = '1.0.0'

# This class stores command line arguments.
class Args
  attr_reader :verbose, :traditional, :greeting

  def initialize
    @verbose = 0
    @traditional = false
    @greeting = 'Hello, world!'

    OptionParser.new do |opts|
      opts.on('-V', '--version', 'Prints version') do
        puts VERSION
        exit
      end

      opts.on('-v', '--verbose', 'Pass many times for more log output') { |v| @verbose += 1 if v }
      opts.on('-t', '--traditional', 'Use traditional greeting') { |v| @traditional = v }
      opts.on('-g', '--greeting=TEXT', 'Use TEXT as the greeting message') { |v| @greeting = v }

      opts.parse!(ARGV)
    end
  end

  def log_level
    if @verbose.zero?
      Logger::WARN
    elsif @verbose == 1
      Logger::INFO
    elsif @verbose >= 2
      Logger::DEBUG
    end
  end
end

def hello(args)
  logger = Logger.new($stderr)
  logger.level = args.log_level

  logger.debug(args)

  if args.traditional
    logger.debug('Printing traditional greeting')
    puts 'hello, world'
  else
    logger.debug('Printing non-traditional greeting')
    puts args.greeting
  end
end

def main
  args = Args.new

  hello(args)
end

main if __FILE__ == $PROGRAM_NAME
