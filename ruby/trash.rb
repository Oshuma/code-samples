#!/usr/bin/env ruby

# Command line tool to send something to the Gnome Trash (with restore info).
# TODO: Support trashing files of the same name (appends numerical id, ex 'filename-2').
class Janitor

  TRASH_DIR = File.expand_path(File.join(ENV['HOME'], '.local/share/Trash'))
  FILES_DIR = File.join(TRASH_DIR, 'files')
  INFO_DIR  = File.join(TRASH_DIR, 'info')

  class << self
    def sweep!(files = [])
      files.each { |file| trash!(file) }
    end

    def trash!(file)
      return unless File.exists?(file)
      $stdout.puts "Trashing #{file}"
      create_info_for(file)
      move_to_trash(file)
    end

    private

    def create_info_for(file)
      info_file = File.join(INFO_DIR, "#{file}.trashinfo")
      raise "Info file exists for #{file}: #{info_file}" if File.exists?(info_file)

      deletion_date = Time.now.strftime("%Y-%m-%dT%H:%M:%S")

      File.open(info_file, 'w') do |info|
        info.puts "[Trash Info]"
        info.puts "Path=#{File.expand_path(file)}"
        info.puts "DeletionDate=#{deletion_date}"
      end
    end

    def move_to_trash(file)
      system "mv #{file} #{FILES_DIR}"
    end

  end # self
end # Janitor


if __FILE__ == $0
  if ARGV.empty?
    $stderr.puts "No file(s) given!\n"
    $stderr.puts "Usage: #{File.basename($0)} <file1>..<fileN>"
    exit
  end

  Janitor.sweep!(ARGV)
end
