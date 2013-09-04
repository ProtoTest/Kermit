# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "Element.rb")

class CTRow < Element
  attr_reader :icon, :date, :type, :compatibilityLabel, :ratingLabel, :infoLink, :createPlanButton

  def initialize(objectString)
    super "PatientRow", objectString
    
    #CT Row Children
      #QHboxLayout, iconLabel, modalityLabel(type), dateLabel, compatibilityLabel, ratingLabel, infoLabel(link), newPlanButton
    
    @icon = Element.new("Row Icon Label", ObjectMap.symbolicName(@children[1]))
    @type = Element.new("Row_Type_Label", ObjectMap.symbolicName(@children[2]))
    @date = Element.new("Date Label", ObjectMap.symbolicName(@children[3]))
    @compatibilityLabel = Element.new("Compatibility Label", ObjectMap.symbolicName(@children[4]))
    @ratingLabel = Element.new("Rating Label", ObjectMap.symbolicName(@children[5]))
    @infoLink = Element.new("Info Link", ObjectMap.symbolicName(@children[6]))
    @createPlanButton = Element.new("Button", ObjectMap.symbolicName(@children[7]))
    
  end
  
  def dClick(timer=nil)
    doubleClick(waitForObject(@symbolicName)) if Squish::Object.exists(@symbolicName)
    if timer
      timer.start
      Test.log("Timer started")
    end
  end
end

class PlanRow < Element
  attr_reader :icon, :type, :date, :planStatusLabel, :planStatusContentsLabel, :byLabel, :byContentsLabel, :openPlanButton

  def initialize(objectString)

    super "PlanRow", objectString
    
    #Plan Row Children
      #QHboxLayout, iconLabel, planLabel(type), dateLabel, planStausLabel, planStatusContentsLabel,
      #byLabel, byContentsLabel, openPlanButton
    
    @icon = Element.new("Row Icon Label", ObjectMap.symbolicName(@children[1]))
    @type = Element.new("Row_Type_Label", ObjectMap.symbolicName(@children[2]))
    @date = Element.new("Date Label", ObjectMap.symbolicName(@children[3]))
    @planStatusLabel = Element.new("Compatibility Label", ObjectMap.symbolicName(@children[4]))
    @planStatusContentsLabel = Element.new("Rating Label", ObjectMap.symbolicName(@children[5]))
    @byLabel = Element.new("Info Link", ObjectMap.symbolicName(@children[6]))
    @byContentsLabel = Element.new("Info Link", ObjectMap.symbolicName(@children[7]))
    @openPlanButton = Element.new("Button", ObjectMap.symbolicName(@children[8]))    
  end  
end



class PatientDetails
  attr_reader :CTRow, :planRows
  
  def initialize
    @CTRow = CTRow.new(":customTreeWidget.frame_QFrame")
    @planRows = getPlanRows 
  end
  

  private
  
  def getPlanRows
    rows = Array.new
    startIndex = 2
    
    begin
      begin
        rowName = "{container=':Form.customTreeWidget_CustomTreeWidget' name='frame' occurrence='%s' type='QFrame' visible='1'}" % startIndex
       
        row=findObject(rowName)
        rows << PlanRow.new(ObjectMap.symbolicName(row))
        startIndex += 1
        
      end while (1)
    rescue Exception => e
    end
    
    return rows
  end
end

class Patient < Element
  def initialize(name, objectString)
    super name, objectString
  end
  
  def click
    super
    return PatientDetails.new
  end
end





def getPatientList
  patientContainer = Element.new("Patient Container", ":Form.customTreeWidget_CustomTreeWidget")
  patientList = Array.new
  
  patientContainer.children.each do |x|
    #Test.log(ObjectMap.symbolicName(x))
    if x.respond_to?(:text) and x.respond_to?(:column) and (x.column==0)
      # If we are dynamically adding patients after they are loaded, the patient objects
      # need to be added to the Object Map
      ObjectMap.add(x)
      patientList << Patient.new(x.text, ObjectMap.symbolicName(x))
    end
  end
  
  return patientList
end
