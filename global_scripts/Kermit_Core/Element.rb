# encoding: UTF-8
require 'squish'

include Squish

OBJECT_WAIT_TIMEOUT= 1000

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
  attr_reader :name, :symbolicName, :realName, :locator
  
  def initialize(name, objectString)
    @name = name
    
    # if ':' is the first character, then it is a symbolic name
    # if '{' is the first character, then this object is initialized from its real name
    if objectString.start_with?(':')
      @symbolicName = objectString
      #@realName = ObjectMap.realName(@symbolicName)
      @locator = objectString
    elsif objectString.start_with?('{') and objectString.end_with?('}')
      @realName = objectString
      #@symbolicName = ObjectMap.symbolicName(@realName)
      @locator = objectString
    else
      raise "Element::init(): objectString is not a valid Squish object string representation"
    end
      
  end
    
  def getChildren
    begin
      elementObject = waitForObject(@locator, OBJECT_WAIT_TIMEOUT)
      children = Squish::Object.children(elementObject)
      return children
    rescue Exception => e
      Test.fail("Element::getChildren(): " + @locator + ": " + e.message)
      return nil
    end
  end
  
  def getProperty(propName)
    begin
      elementObject = waitForObject(@locator, OBJECT_WAIT_TIMEOUT)
      @properties = Squish::Object.properties(elementObject)
            
      if @properties[propName]
        return @properties[propName]
      else
        Test.log("Element::getProperty(): " + propName + "property does not exist for element: " + @locator)
        return nil
      end
    rescue Exception => e
      Test.fail("Element::getProperty(): " + @locator + ": " + e.message)
    end
  end
  
  def to_s
    "[name, symbolicName, realName]: " + @name + ", " + @locator #+ ", " + @realName
  end
  
end