
class LogCommandBuilder
  def initialize
  end
  
  def click(element)
    _return = "MouseClick on: \"" + element.symName + "\""
    return _return
  end

  def type(element, someText)
    _return = "Type \"" + someText + "\" into: \"" + element.symName + "\""
    return _return
  end
  
  def move(element)
    _return = "Move mouse to " + element.symName
    return _return
  end
end