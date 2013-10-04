require findFile("scripts", "kermit_core\\TestLogger.rb")
require findFile("scripts", "kermit_core\\LogCommandBuilder.rb")

 @@logCmd = LogCommandBuilder.new  
 @@logFile = TestLogger.new

TestSettings.logScreenshotOnFail = true

MAX_NUM_VISIBLE_TABLE_ROWS = 15
OBJECT_WAIT_TIMEOUT= 10000

module RadioButtons
  LOAD_IMAGES = 1
  ADD_TARGETS = 2
  ADD_ABLATION = 3
  EXPORT = 4
end


