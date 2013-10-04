# encoding: UTF-8
require 'squish'

include Squish

# to get access to the logging click methods
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")


# OBJECT_WAIT_TIMEOUT= 10000 --Moved to TestConfig.Rb

########################################################################################
#
#  Element
#     Encapsulates a QT object details (i.e., real name, symbolic name, object children,
#       object properties
#
#  @author  Matt Siwiec
#  @notes
#
########################################################################################
class Element
  attr_reader :name, :symbolicName, :realName
  
  def initialize(name, objectString)
    @name = name
    
    # if ':' is the first character, then it is a symbolic name
    # if '{' is the first character, then this object is initialized from its real name
    if objectString.start_with?(':')
      @symbolicName = objectString
      @realName = ObjectMap.realName(@symbolicName)
    elsif objectString.start_with?('{') and objectString.end_with?('}')
      @realName = objectString
      @symbolicName = ObjectMap.symbolicName(@realName)
    else
      raise "Element::init(): objectString is not a valid Squish object string representation"
    end
      
  end
    
  def hasChildren?
    children = getChildren
    return false if children.empty? or children.nil?
    return true
  end
  
  def hasProperty?(propName)
    property = getProperty(propName)
    return false if property.nil?
    return true
  end

  def getChildren
    begin
      elementObject = waitForObject(@symbolicName, OBJECT_WAIT_TIMEOUT)
      children = Squish::Object.children(elementObject)
      return children
    rescue Exception => e
      Test.fail("Element::getChildren(): " + @symbolicName + ": " + e.message)
      return nil
    end
  end
  
  def getProperty(propName)
    begin
      elementObject = waitForObject(@symbolicName, OBJECT_WAIT_TIMEOUT)
      @properties = Squish::Object.properties(elementObject)
            
      if @properties[propName]
        return @properties[propName]
      else
        # Property does not exist
        return nil
      end
    rescue Exception => e
      Test.fail("Element::getProperty(): " + @symbolicName + ": " + e.message)
    end
  end

  def getText
    return getProperty('text')
  end
  
   
 #Moved from Scrollbar class into element class -SU
  def scrollUp
  	h = getProperty('height')
    w = getProperty('width')
    mouseClick(symbolicName, w/2, 20, 0, Qt::LEFT_BUTTON)
  end

  def scrollDown
  	h = getProperty('height')
    w = getProperty('width')
    mouseClick(symbolicName, w/2, h-20, 0, Qt::LEFT_BUTTON)
  end
  
  def to_s
    "[name, symbolicName, realName]: " + @name + ", " + @realName
  end
  
 #Moved from BaseScreenObject
def enterText(someText)
    mouseClick(waitForObject(@symbolicName))
    @@logFile.AppendLog(@@logCmd.click(self))
    type(waitForObject(@symbolicName), someText)
    @@logFile.AppendLog(@@logCmd.type(self, someText))
 end

 def click      
    mouseClick(waitForObject(@symbolicName))
    @@logFile.AppendLog(@@logCmd.click(self))     
  end
  
 def dClick
    doubleClick(waitForObject(@symbolicName))
    @@logFile.AppendLog(@@logCmd.dClick(self))
  end
  
  #This function is used by the move and drag functions
  def checkAmount(amount, var)
    valid = false
    if amount > var
        valid = true
    end
    return valid
  end
  
  def moveTarget(direct, amount)
      direction = direct.upcase
      w = getProperty("width")
      h = getProperty("height")
      cw = w/2
      ch = h/2
      if checkAmount(amount, cw) || checkAmount(amount, ch)
        @@logFile.AppendLog("WARNING: Target may not have been moved, to great of an amount specified! WARNING!")
      end

      if direction == "LEFT" || direction == "L"
        mouseClick(@symbolicName, (cw - amount), 0, 0, Qt::LEFT_BUTTON)
        mouseRelease()
      end
      if direction == "RIGHT" || direction == "R"
        mouseClick(@symbolicName, (cw + amount), 0, 0, Qt::LEFT_BUTTON)
        mouseRelease()
      end
      if direction == "UP" || direction == "U"
        mouseClick(@symbolicName, (ch + amount), 0, 0, Qt::LEFT_BUTTON)
        mouseRelease()
      end
      if direction == "DOWN" || direction == "D"
        mouseClick(@symbolicName, (ch - amount), 0, 0, Qt::LEFT_BUTTON)
        mouseRelease()
      end
      @@logFile.AppendLog(@@logCmd.moveTarget(element, direction, amount))
  end
  
  def dragTarget(direct, amount)
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
      mouseDrag(@symbolicName, start, ch, start - amount, 0, 1, Qt::LEFT_BUTTON)
      mouseRelease()
    end
    if direction == "RIGHT" || direction == "R"
      start = 5
      mouseDrag(@symbolicName, start, ch, start + amount, 0, 1, Qt::LEFT_BUTTON)
      mouseRelease()
    end
    if direction == "UP" || direction == "U"
      start = h - 5
      mouseDrag(@symbolicName, cw, start, 0, start - amount, 1, Qt::LEFT_BUTTON)
      mouseRelease()
    end
    if direction == "DOWN" || direction == "D"
      start = 5
      mouseDrag(@symbolicName, cw, start, 0, start + amount, 1, Qt::LEFT_BUTTON)
      mouseRelease()
    end
    @@logFile.AppendLog(@@logCmd.moveTarget(element, direction, amount), snagScreenshot(element))
end
  
  
end