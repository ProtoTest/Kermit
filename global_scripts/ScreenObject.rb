# encoding: UTF-8
require findFile("scripts", "TestLogger.rb")
require findFile("scripts", "LogCommandBuilder.rb")

class BaseScreenObject
  @@logCmd = LogCommandBuilder.new  
  @@logFile = TestLogger.new
    

    
    def initialize
     #this doesn't get called by the child classes
     
    end
  
      
    def enterText(element, someText)
      mouseClick(waitForObject(element.symName))
      @@logFile.AppendLog(@@logCmd.click(element))
      type(waitForObject(element.symName), someText)
      @@logFile.AppendLog(@@logCmd.type(element, someText))
    end
    
    def click(element)      
      mouseClick(waitForObject(element.symName))
      @@logFile.AppendLog(@@logCmd.click(element))     
    end
    
    def dClick(element)
      doubleClick(waitForObject(element.symName))
      @@logFile.AppendLog(@@logCmd.dClick(element))
    end
    
  def moveTarget(element, direct, amount)
      direction = direct.upcase
      w = element.getProperty("width")
      h = element.getProperty("height")
      cw = w/2
      ch = h/2
      if direction == "LEFT" || direction == "L"
        mousePress(element.symName, (cw - amount), 0)
        mouseRelease()
      end
      if direction == "RIGHT" || direction == "R"
        mousePress(element.symName, (cw + amount), 0)
        mouseRelease()
      end
      if direction == "UP" || direction == "U"
        mousePress(element.symName, (ch + amount), 0)
        mouseRelease()
      end
      if direction == "DOWN" || direction == "D"
        mousePress(element.symName, (ch - amount), 0)
        mouseRelease()
      end
      @@logFile.AppendLog("Moved Target in " + element.symName + " " + direction + " " + amount.to_s + " pixels")
    end
    
    
    
end
