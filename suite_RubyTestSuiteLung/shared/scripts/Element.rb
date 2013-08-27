# encoding: UTF-8
require 'squish'

include Squish

class Element
  attr_reader :symName, :realName, :elementObject
  
  def initialize(objectString)
    begin
      # if ':' is the first character, then it is a symbolic name
      # if '{' is the first character, then this object is initialized from its real name
      if objectString.start_with?(':')
        @symName = objectString
        @realName = ObjectMap.realName(@symName)
      elsif objectString.start_with?('{') and objectString.end_with?('}')
        @realName = objectString
        @symName = ObjectMap.symbolicName(@realName)
      else
        raise "objectString is not a valid object string representation"
      end
    
      @elementObject = findObject(symName)
      @properties = Squish::Object.properties(@elementObject)
    rescue Exception => e
      Test.fail(objectString + ": " + e.message)
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
  
  def doubleClick
    doubleClick(@elementObject)
  end
  
  def to_s
    "[symName, realName]: " + @symName + ", " + @realName
  end
end

class TextInputElement < Element
  def initialize(objectString)
    super objectString
  end
  
  def enterText(text)
    type(@elementObject, text)
  end
  
  def clear
    @elementObject.text = ""
  end
end

class SliderElement < Element
  def initialize(objectString)
    super objectString
  end
  
  def setSliderValue(value)
    if value.between?(@elementObject.minimum, @elementObject.maximum)
      @elementObject.sliderPosition = value
    else
      raise "Slider value out of bounds exception"
    end
  end
end