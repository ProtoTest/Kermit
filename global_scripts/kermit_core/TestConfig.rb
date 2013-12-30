require findFile("scripts", "kermit_core\\TestLogger.rb")
require findFile("scripts", "kermit_core\\LogCommandBuilder.rb")

# External ruby version: Required for the ability to send emails with SSL upon completion of tests.
# Squish version is pretty old.
# This will be the folder location on the C: drive
RUBY_VERSION_EXTERNAL = "Ruby200-x64"

# Send Email upon test completion
SEND_EMAIL = true

# Logging initialization

# output trace logs
LOG_TRACE= true

@@logCmd = LogCommandBuilder.new
@@logFile = TestLogger.new

# number of visible rows in the patient table (adjust according to resolution)
MAX_NUM_VISIBLE_TABLE_ROWS = 15

# 10 second timeout for squish to find and wait for objects
OBJECT_WAIT_TIMEOUT = 10000


