# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "Element.rb")

class PatientTable < Element
  attr_reader :patientList
  
  def initialize(objectString)
    super objectString
    loadPatientObjectList
  end
  
  
  private
  
  def loadPatientObjectList
    myChildren = Squish::Object.children(@elementObject)
    @patientList = Array.new
    
    myChildren.each do |x|
      #Test.log(ObjectMap.symbolicName(x))
      if x.respond_to?(:text) and x.respond_to?(:column) and (x.column==0)
        # If we are dynamically adding patients after they are loaded, the patient objects
        # need to be added to the Object Map
        ObjectMap.add(x)
        @patientList << Element.new(ObjectMap.symbolicName(x))
      end
    end
  end
end