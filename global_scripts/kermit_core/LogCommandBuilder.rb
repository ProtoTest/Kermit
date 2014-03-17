########################################################################################
#
#  Log Command builder
#     This is used to add standard comments to the log file
#
#  @author  Seth Urban
#  @notes -10/04/2013 - SU - added standard header
#
########################################################################################


class LogCommandBuilder
  def initialize
  end

  def click(element)
    return "MouseClick on: \"" + element.name + " " + element.symbolicName + "\""
  end

  def dClick(element)
    return "MouseDoubleClick on: \"" + element.name + " " + element.symbolicName  + "\""
  end

  def type(element, someText)
    return "Type \"" + someText + "\" into: \"" + element.name + " " + element.symbolicName + "\""
  end

  def move(element)
    return "Move mouse to " + element.name + " " + element.symbolicName
  end

  def moveTarget(element, direct, amount)
    return "Moved Target in" + element.symbolicName + " "  + direct + " " + amount.to_s + " pixels"
  end

end