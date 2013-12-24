require findFile("scripts", "kermit_core\\Common.rb")
require findFile("scripts", "kermit_core\\TestLogger.rb")
require findFile("scripts", "kermit_core\\LogCommandBuilder.rb")

# Logging initialization

# Send Email upon test completion
SEND_EMAIL = false

# output trace logs
LOG_TRACE= true

@@logCmd = LogCommandBuilder.new
@@logFile = TestLogger.new

# number of visible rows in the patient table (adjust according to resolution)
MAX_NUM_VISIBLE_TABLE_ROWS = 15

# 10 second timeout for squish to find and wait for objects
OBJECT_WAIT_TIMEOUT = 10000


# call this to finalize the test and build the HTML test log
def completeTest
  @@logFile.CompleteLog()

  # TODO: Get the test name that completed
  send_email("Test Completed", "Test Completed")
end

#
# install crash, hang, etc event handlers
#
def crashHandler
  # perform any necessary cleanup here

  # Log and fail
  @@logFile.TestFatal("Application under test '#{currentApplicationContext().name}' crashed")
  completeTest
end

def timeoutHandler
  # perform any necessary cleanup here

  # Log and fail
  @@logFile.TestFatal("Application under test '#{currentApplicationContext().name}' timed-out")
  completeTest
end

def installEventHandlers
  @@logFile.TestLog("#{__method__}: Registering event handlers")
  installEventHandler("Crash", "crashHandler")
  installEventHandler("Timeout", "timeoutHandler")
end


