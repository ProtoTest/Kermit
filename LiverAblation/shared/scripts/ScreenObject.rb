# encoding: UTF-8
require findFile("scripts", "TestLogger.rb")

class BaseScreenObject
  def initialize
    @logFile = TestLogger.new
  end
  
  def enterText(element, someText)    
    mouseClick(waitForObject(element.symbolicName))
    type(waitForObject(element.symbolicName), someText)    
  end
  
end