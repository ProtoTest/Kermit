# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "Element.rb")
require findFile("scripts", "AddTargetScreen.rb")

########################################################################################
#
#  Patient table header component
#     Stores object elements for the Patient table header
#
#  @author  Matt Siwiec
#  @notes
#
########################################################################################
class TableHeader
  attr_reader :patientNameHeaderView, :patientIDHeaderView, :birthDateHeaderView, :lastAccessHeaderView
  
  def initialize
    # Table Headers
    @patientNameHeaderView = Element.new("Patient Name Table Header", ":Patient Name_HeaderViewItem")
    @patientIDHeaderView = Element.new("Patient ID Table Header", ":Patient ID_HeaderViewItem")
    @birthDateHeaderView = Element.new("Birth Date Table Header", ":Birth Date_HeaderViewItem")
    @lastAccessHeaderView = Element.new("Last Accessed Table Header", ":Last Accessed_HeaderViewItem")
  end
end

########################################################################################
#
#  Cat Scan Row component
#   Stores object elements of the CT row for a patient
#
#  @author Matt Siwiec
#  @notes Inherits from Element
#
########################################################################################
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
end

########################################################################################
#
#  Plan Row component
#   Stores object elements of a Plan row for a patient
#
#  @author Matt Siwiec
#  @notes Inherits from Element
#
########################################################################################
class PlanRow  < Element
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


########################################################################################
#
#  Patient Details
#     Stores the object elements for a Patient's CT and plan rows
#
#  @author    Matt Siwiec
#  @notes     In order to get access to the rows objects, the patient name must be 'clicked'
#             to open the sub-tree of patient details            
#
########################################################################################
class PatientDetails
  attr_reader :planRows
  
  def initialize
    @CTRow = CTRow.new(":customTreeWidget.frame_QFrame")
    @planRows = getPlanRows 
  end
  
  # Clicks on the create new plan button 
  def createNewPlan
    @CTRow.createPlanButton.click
    return AddTargetScreen.new
  end

  # Double clicks the patient's CT scan to open it
  def openCTScan 
    @CTRow.dClick
  end
  
  private
  
  def getPlanRows
    rows = Array.new
    startIndex = 2
    
    begin
      begin
        # each patient plan row is indexed via the 'occurrence' property
        rowName = "{container=':Form.customTreeWidget_CustomTreeWidget' name='frame' occurrence='%s' type='QFrame' visible='1'}" % startIndex
       
        row=waitForObject(rowName, OBJECT_WAIT_TIMEOUT)
        rows << PlanRow.new(ObjectMap.symbolicName(row))
        startIndex += 1
        
      end while (1)
    rescue Exception => e
      # don't care, this is used as the condition to break from the while
    end
    
    return rows
  end
end

########################################################################################
#
#  Patient
#     Stores a reference to the patient element object
#
#  @author    Matt Siwiec
#  @notes     Provides functionality for the tester to get the patient details from the sub-tree
#
########################################################################################
class Patient
  attr_reader :name

  def initialize(name, objectString)
    @name = name
    @patientElement = Element.new(name, objectString)
  end
  
  # Returns the patient details (CT Row, Plan Rows)
  def openPatientDetails
    mouseClick(waitForObject(@patientElement.symbolicName))  if Squish::Object.exists(@patientElement.symbolicName)
    return PatientDetails.new
  end
  
end


########################################################################################
#
#  PatientTable
#     Stores the components of all patients in the table
#
#  @author  Matt Siwiec
#  @notes
#
########################################################################################
class PatientTable
  attr_reader :patientList

  def initialize
    @tableHeader = TableHeader.new
    @patientList = getPatientList
  end


  private

  # Returns the list of patients found within the container
  def getPatientList
    patientContainer = Element.new("Patient Container", ":Form.customTreeWidget_CustomTreeWidget")
    patientList = Array.new

    patientContainer.children.each do |x|
      if x.respond_to?(:text) and x.respond_to?(:column) and (x.column==0)
        # If we are dynamically adding patients after they are loaded, the patient objects
        # need to be added to the Object Map
        ObjectMap.add(x)
        patientList << Patient.new(x.text, ObjectMap.symbolicName(x))
      end
    end

    return patientList
  end

end

