# encoding: UTF-8
require findFile("scripts", "TestLogger.rb")

class BaseScreenObject
  def initialize
      @logFile = ""
    end
  
    def initLog(testName)
      @logFile = testName
    end
  
    def enterText(element, someText)
      mouseClick(waitForObject(element.symbolicName))
      @logFile.AppendLog("MouseClick on: " + element.symbolicName)
      type(waitForObject(element.symbolicName), someText)
      @logFile.AppendLog("Type " + someText + " into: " + element.symbolicName)
    end
  
end