#####################################################
# Seth Urban - 09/05/13
# This class is used to build uniform commands to the log file
# as strings
#####################################################


class LogCommandBuilder
  def initialize
  end
  
  def click(element)
    _return = "MouseClick on: \"" + element.name + " " + element.symbolicName + "\""
    return _return
  end

  def dClick(element)
    _return = "MouseDoubleClick on: \"" + element.name + " " + element.symbolicName  + "\""
    return _return
  end

  def type(element, someText)
    _return = "Type \"" + someText + "\" into: \"" + element.name + " " + element.symbolicName + "\""
    return _return
  end
  
  def move(element)
    _return = "Move mouse to " + element.name + " " + element.symbolicName
    return _return
  end

  def moveTarget(element, direct, amount)
    _return = "Moved Target in" + element.symbolicName + " "  + direct + " " + amount.to_s + " pixels"
    return _return
  end
end