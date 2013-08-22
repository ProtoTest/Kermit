# encoding: UTF-8
require 'squish'

include Squish

class Element
  attr_reader :symName, :realName
  
  def initialize(symbolicName)
    @symName = symbolicName
    @realName = ObjectMap.realName(symName)
    begin
      @elementObject = findObject(symName)
      @properties = Squish::Object.properties(@elementObject)
    rescue Exception => e
      Test.fail(@symName + ": " + e.message)
    end      
  end
    
  def getProperty(propName)
    if @properties[propName]
      return @properties[propName]
    else
      Test.fail(propName + "property does not exist for element: " + symName)
      return nil
    end
  end

  def click
    mouseClick(@elementObject)
  end
  
  def hasChildren?
    myChildren = Squish::Object.children(@elementObject)
    Test.log("children size: " + myChildren.size.to_s)
    (myChildren.size > 0) ? true : false
  end
  
  def printChildren
    myChildren = Squish::Object.children(@elementObject)
    myChildren.each do |x|
      Test.log(x.text)
    end
  end
  
  def to_s
    "[symName, realName]: " + @symName + ", " + @realName
  end
end

class TextElement < Element
  def initialize(symbolicName)
    super symbolicName
  end
  
  def enterText(text)
    type(@elementObject, text)
  end
end