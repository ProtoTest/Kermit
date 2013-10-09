require findFile("scripts", "kermit_core\\TestLogger.rb")
require findFile("scripts", "kermit_core\\LogCommandBuilder.rb")

 @@logCmd = LogCommandBuilder.new  
 @@logFile = TestLogger.new

MAX_NUM_VISIBLE_TABLE_ROWS = 15
OBJECT_WAIT_TIMEOUT= 10000

module RadioButtons
  LOAD_IMAGES = 1
  ADD_TARGETS = 2
  ADD_ABLATION = 3
  EXPORT = 4
end

#
# install crash, hang, etc event handlers
#
def crashHandler
  # perform any necessary cleanup here

  # Log and fail
  @@logFile.TestFatal("Application under test '#{currentApplicationContext().name}' crashed")
end

def timeoutHandler
  # perform any necessary cleanup here

  # Log and fail
  @@logFile.TestFatal("Application under test '#{currentApplicationContext().name}' timed-out")
end

def installEventHandlers
  @@logFile.TestLog("#{__method__}: Registering event handlers")
  installEventHandler("Crash", "crashHandler")		
  installEventHandler("Timeout", "timeoutHandler")
end


