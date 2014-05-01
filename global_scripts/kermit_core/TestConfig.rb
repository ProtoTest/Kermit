require findFile("scripts", "kermit_core\\TestLogger.rb")
require findFile("scripts", "kermit_core\\LogCommandBuilder.rb")

# External ruby version: Required for the ability to send emails with SSL upon completion of tests.
# Squish version is pretty old.
# This will be the folder location on the C: drive
RUBY_VERSION_EXTERNAL = "Ruby200-x64"

# Send Email upon test completion
SEND_EMAIL = false

# Logging initialization

# output trace logs
LOG_TRACE= true

@@logCmd = LogCommandBuilder.new
Log = @@logFile = TestLogger.new

# number of visible rows in the patient table (adjust according to resolution)
MAX_NUM_VISIBLE_TABLE_ROWS = 15

# 10 second timeout for squish to find and wait for objects
OBJECT_WAIT_TIMEOUT = 10000

########################
# Smoke Test Variables #
########################

# Number of tabs to create in the smoke test tab test case
TABS_TO_CREATE = 2

NUMBER_OF_SNAPSHOTS_TO_TAKE = 2

UNICODE_DATAPOINTS = [(0x0040...0x007e).to_a,
                      (0x00c0...0x02Af).to_a,
                      (0x1d00...0x1dbf).to_a,
                      (0x1e00...0x1eff).to_a,
                      (0x2100...0x24ef).to_a,
                      (0x2c60...0x2c7f).to_a].flatten
