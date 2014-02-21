# Make sure you run this script from this directory or symlink to it. As you can see below there is a
# relative path to the script code to actually generate the HTML log.

require File.join(File.dirname(__FILE__), "..//global_scripts//kermit_core//HTML_LogGenerator.rb")

def usage
  "Usage: #{$PROGRAM_NAME} <test name> <log_dir> <infile.txt>"
end

# CLO?
if ARGV.length != 3
  abort usage
else
  TEST_NAME = ARGV[0].gsub(/\s+/, "")
  LOG_DIR = ARGV[1]
  INFILE = ARGV[2]
end

begin
  HTML_LogGenerator.generate(TEST_NAME, LOG_DIR, INFILE)
rescue Exception => e
  puts "Failed to generate HTML log file: #{e.message}"
end