# encoding: UTF-8
require 'squish'

include Squish

class Element
  attr_reader :name, :symbolicName, :realName, :elementObject
  
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
    
      @elementObject = findObject(@symbolicName)
      @properties = Squish::Object.properties(@elementObject)
    rescue Exception => e
      Test.fail(objectString + ": " + e.message)
    end      
  end
    
  def getProperty(propName)
    if @properties[propName]
      return @properties[propName]
    else
      Test.fail(propName + "property does not exist for element: " + @symbolicName)
      return nil
    end
  end

  def click
    mouseClick(@elementObject)
  end
  
  def doubleClick
    doubleClick(@elementObject)
  end
  
  def to_s
    "[name, symbolicName, realName]: " + @name + ", " + @symbolicName + ", " + @realName
  end
end