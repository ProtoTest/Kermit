##################################################
# Seth Urban - 09/05/13
# This is the template class where child classes will be instantiated from
# containing all the basic API functionality from SQUISH that to be abstracted from the
# test engineer.
##################################################


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
    mouseClick(waitForObject(element.symbolicName))
    @@logFile.AppendLog(@@logCmd.click(element))
    type(waitForObject(element.symbolicName), someText)
    @@logFile.AppendLog(@@logCmd.type(element, someText))
  end
  
  def click(element)      
    mouseClick(waitForObject(element.symbolicName))
    @@logFile.AppendLog(@@logCmd.click(element))     
  end
  
  def dClick(element)
    doubleClick(waitForObject(element.symbolicName))
    @@logFile.AppendLog(@@logCmd.dClick(element))
  end

  ##Need to check to make sure the amount clicked is in the size
  def moveTarget(element, direct, amount)
      direction = direct.upcase
      w = element.getProperty("width")
      h = element.getProperty("height")
      cw = w/2
      ch = h/2
      if checkAmount(amount, cw) || checkAmount(amount, ch)
        @@logFile.AppendLog("WARNING: Target may not have been moved, to great of an amount specified! WARNING!")
      end

      if direction == "LEFT" || direction == "L"
        mouseClick(element.symbolicName, (cw - amount), 0, 0, Qt::LEFT_BUTTON)
        mouseRelease()
      end
      if direction == "RIGHT" || direction == "R"
        mouseClick(element.symbolicName, (cw + amount), 0, 0, Qt::LEFT_BUTTON)
        mouseRelease()
      end
      if direction == "UP" || direction == "U"
        mouseClick(element.symbolicName, (ch + amount), 0, 0, Qt::LEFT_BUTTON)
        mouseRelease()
      end
      if direction == "DOWN" || direction == "D"
        mouseClick(element.symbolicName, (ch - amount), 0, 0, Qt::LEFT_BUTTON)
        mouseRelease()
      end
      @@logFile.AppendLog(@@logCmd.moveTarget(element, direction, amount))
    end

  ##Need to check to make sure the amount dragged is in the target
  def dragTarget(element, direct, amount)
    direction = direct.upcase
    w = element.getProperty("width")
    h = element.getProperty("height")
    cw = w/2
    ch = h/2

    if checkAmount(amount, w) || checkAmount(amount, h)
      @@logFile.AppendLog("WARNING: Target may not have been dragged, to great of an amount specified! WARNING!")
    end

    #to drag left you must start on the right
    if direction == "LEFT" || direction == "L"
      start = w - 5 #pick a position on the inside of the right edge
      mouseDrag(element.symbolicName, start, ch, start - amount, 0, 1, Qt::LEFT_BUTTON)
      mouseRelease()
    end
    if direction == "RIGHT" || direction == "R"
      start = 5
      mouseDrag(element.symbolicName, start, ch, start + amount, 0, 1, Qt::LEFT_BUTTON)
      mouseRelease()
    end
    if direction == "UP" || direction == "U"
      start = h - 5
      mouseDrag(element.symbolicName, cw, start, 0, start - amount, 1, Qt::LEFT_BUTTON)
      mouseRelease()
    end
    if direction == "DOWN" || direction == "D"
      start = 5
      mouseDrag(element.symbolicName, cw, start, 0, start + amount, 1, Qt::LEFT_BUTTON)
      mouseRelease()
    end
    @@logFile.AppendLog(@@logCmd.moveTarget(element, direction, amount), snagScreenshot(element))
  end

  def checkAmount(amount, var)
    valid = false
    if amount > var
        valid = true
    end
    return valid
  end

  def snagScreenshot(element)
    thing = waitForObject(element.symbolicName)
    image = grabWidget(thing)
    format = "PNG"
    ssName = element.name + "." + format
    ssLoc = @@logFile.testLogLocation
    image.save(ssLoc + ssName, format)
    return ssName
  end


    
end
