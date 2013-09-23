# encoding: UTF-8
require 'squish'

include Squish

# to get access to the logging click methods
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")


OBJECT_WAIT_TIMEOUT= 10000

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
  
  def click
    BaseScreenObject.click(self)
  end
  
  def dClick
    BaseScreenObject.dClick(self)
  end
  
  def to_s
    "[name, symbolicName, realName]: " + @name + ", " + @realName
  end
  
end