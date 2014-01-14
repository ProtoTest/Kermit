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

    begin
      # if ':' is the first character, then it is a symbolic name
      # if '{' is the first character, then this object is initialized from its real name
      if objectString.start_with?(':')
        @symbolicName = objectString
        @realName = ObjectMap.realName(@symbolicName)
      elsif objectString.start_with?('{') and objectString.end_with?('}')
        @realName = objectString
        @symbolicName = ObjectMap.symbolicName(@realName)
      else
        raise "Element::init(): #{objectString} is not a valid Squish object string representation"
      end
    rescue Exception => e
      Log.TestFail("#{self.class.name}::#{__method__}(): Failed to initialize '#{@name}'' with object string '#{objectString}': #{e.messge}")
    end
  end

  # Returns true if the element exists on the screen, false otherwise
  def onScreen?
    return Squish::Object::exists(@symbolicName)
  end

  # Returns true if the element has any child squish objects, false otherwise
  def hasChildren?
    children = getChildren
    return false if children.empty? or children.nil?
    return true
  end

  # Returns true if the element has the object property
  # Params: propName - String representing the property to query
  def hasProperty?(propName)
    property = getProperty(propName)
    return false if property.nil?
    return true
  end

  # Returns and array of squish object children for the element
  def getChildren
    begin
      elementObject = waitForObject(@symbolicName, OBJECT_WAIT_TIMEOUT)
      children = Squish::Object.children(elementObject)
      return children
    rescue Exception => e
	    Log.TestFail("#{self.class.name}::#{__method__}(): Failed to get children for #{@name}: #{e.message}")
      return nil
    end
  end

  # Returns the property value for the requested property name
  # Param: propName - String representing the property to retrieve
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
      Log.TestFail("#{self.class.name}::#{__method__}(): " + @symbolicName + ": " + e.message)
    end
  end

  # Retrieve the value for the text property of the element
  def getText
    return getProperty('text')
  end

  # Set the text property for the element
  # Param: someText - String of text to set
  def setText(someText)
    object = waitForObject(@symbolicName)
    object.setText(someText)
  end

  def getTextArea
    return getProperty('plainText')
  end

  # For an element that is a scroll bar, click to scroll up
  def scrollUp
  	h = getProperty('height')
    w = getProperty('width')
    mouseClick(waitForObject(@symbolicName, OBJECT_WAIT_TIMEOUT), w/2, 20, 0, Qt::LEFT_BUTTON)
  end

  # For an element that is a scroll bar, click to scroll down
  def scrollDown
  	h = getProperty('height')
    w = getProperty('width')
    mouseClick(waitForObject(@symbolicName, OBJECT_WAIT_TIMEOUT), w/2, h-20, 0, Qt::LEFT_BUTTON)
  end

  # To string representation of the element
  def to_s
    "[name, symbolicName, realName]: #{@name}, #{@symbolicName}, #{@realName}"
  end

  # Enter text into the text field
  # Param: someText - String of text to set
  def enterText(someText)
    object = waitForObject(@symbolicName)
    object.text = ""
    type(waitForObject(@symbolicName), someText)
    Log.AppendLog(@@logCmd.type(self, someText))
  end

  # Single click on the element
  def click
    mouseClick(waitForObject(@symbolicName))
    Log.AppendLog(@@logCmd.click(self))
  end

  # Double-click on the element
  def dClick
    doubleClick(waitForObject(@symbolicName))
    Log.AppendLog(@@logCmd.dClick(self))
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
        Log.AppendLog("WARNING: Target may not have been moved, to great of an amount specified! WARNING!")
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
      Log.AppendLog(@@logCmd.moveTarget(element, direction, amount))
  end

  def dragTarget(direct, amount)
    direction = direct.upcase
    w = element.getProperty("width")
    h = element.getProperty("height")
    cw = w/2
    ch = h/2

    if checkAmount(amount, w) || checkAmount(amount, h)
      Log.AppendLog("WARNING: Target may not have been dragged, to great of an amount specified! WARNING!")
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
    Log.AppendLog(@@logCmd.moveTarget(element, direction, amount), snagScreenshot(element))
end

  # Take a screenshot of the just the element
  def snagScreenshot
    thing = waitForObject(@symbolicName)
    image = grabWidget(thing)
    format = "PNG"
    ssName = element.name + "." + format
    ssLoc = Log.testLogLocation
    image.save(ssLoc + ssName, format)
    Log.ApendLog("Taking screenshot of: " + @name + " symbolicName: " + @symbolicName + " and saving to Location: " + ssLoc)
    return ssName
  end


end