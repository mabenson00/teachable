#!/usr/bin/env ruby

require 'irb'
require_relative '../lib/todoable'

def reload!(print = true)
  puts 'Reloading ...' if print
  # Main project directory.
  root_dir = File.expand_path('..', __dir__)
  # Directories within the project that should be reloaded.
  reload_dirs = %w{lib}
  # Loop through and reload every file in all relevant project directories.
  reload_dirs.each do |dir|
    Dir.glob("#{root_dir}/#{dir}/**/*.rb").each { |f| load(f) }
  end
  # Return true when complete.
  true
end

IRB.start