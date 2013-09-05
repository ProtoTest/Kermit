# encoding: UTF-8
require 'squish'

include Squish

OBJECT_WAIT_TIMEOUT= 5000

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
  attr_reader :name, :symbolicName, :realName, :children
  
  def initialize(name, objectString)
    begin
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
        raise "objectString is not a valid object string representation"
      end
    
      elementObject = waitForObject(@symbolicName, OBJECT_WAIT_TIMEOUT)
      @properties = Squish::Object.properties(elementObject)
      @children = Squish::Object.children(elementObject)
    rescue Exception => e
      Test.fail(objectString + ": " + e.message)
    end      
  end
    
  def getProperty(propName)
    if @properties[propName]
      return @properties[propName]
    else
      Test.log(propName + "property does not exist for element: " + @symbolicName)
      return nil
    end
  end

  def click
    mouseClick(waitForObject(@symbolicName, OBJECT_WAIT_TIMEOUT))  if Squish::Object.exists(@symbolicName)
  end
  
  def dClick
    doubleClick(waitForObject(@symbolicName, OBJECT_WAIT_TIMEOUT)) if Squish::Object.exists(@symbolicName)
  end
  
  
    
  def to_s
    "[name, symbolicName, realName]: " + @name + ", " + @symbolicName + ", " + @realName
  end
end