# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "Element.rb")
require findFile("scripts", "BaseScreenObject.rb")
require findFile("scripts", "EditTargetScreen.rb")

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

  def initialize(objectString)
    super("PatientRow", objectString)
    
    #CT Row Children
      #QHboxLayout, iconLabel, modalityLabel(type), dateLabel, compatibilityLabel, ratingLabel, infoLabel(link), newPlanButton
    
    objectChildren = getChildren
    
    @icon = Element.new("Row Icon Label", ObjectMap.symbolicName(objectChildren[1]))
    @type = Element.new("Row_Type_Label", ObjectMap.symbolicName(objectChildren[2]))
    @date = Element.new("Date Label", ObjectMap.symbolicName(objectChildren[3]))
    @compatibilityLabel = Element.new("Compatibility Label", ObjectMap.symbolicName(objectChildren[4]))
    @ratingLabel = Element.new("Rating Label", ObjectMap.symbolicName(objectChildren[5]))
    @infoLink = Element.new("Info Link", ObjectMap.symbolicName(objectChildren[6]))
    @createPlanButton = Element.new("Button", ObjectMap.symbolicName(objectChildren[7]))
    
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

  def initialize(objectString)

    super("PlanRow", objectString)
    
    #Plan Row Children
      #QHboxLayout, iconLabel, planLabel(type), dateLabel, planStausLabel, planStatusContentsLabel,
      #byLabel, byContentsLabel, openPlanButton
    
    objectChildren = getChildren
    
    @icon = Element.new("Row Icon Label", ObjectMap.symbolicName(objectChildren[1]))
    @type = Element.new("Row_Type_Label", ObjectMap.symbolicName(objectChildren[2]))
    @date = Element.new("Date Label", ObjectMap.symbolicName(objectChildren[3]))
    @planStatusLabel = Element.new("Compatibility Label", ObjectMap.symbolicName(objectChildren[4]))
    @planStatusContentsLabel = Element.new("Rating Label", ObjectMap.symbolicName(objectChildren[5]))
    @byLabel = Element.new("Info Link", ObjectMap.symbolicName(objectChildren[6]))
    @byContentsLabel = Element.new("Info Link", ObjectMap.symbolicName(objectChildren[7]))
    @openPlanButton = Element.new("Button", ObjectMap.symbolicName(objectChildren[8]))    
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
class PatientDetails < BaseScreenObject
  
  def initialize
    # using real name for squish here as the symbolic names differ across liver and lung applications
    @CTRow = CTRow.new("{container=':Form.customTreeWidget_CustomTreeWidget' name='frame' type='QFrame' visible='1'}")
    @planRows = getPlanRows 
  end
  
  # Clicks on the create new plan button 
  def createNewPlan
    click(@CTRow.createPlanButton)
    return EditTargetScreen.new
  end

  # Double clicks the patient's CT scan to open it
  def openCTScan 
    dClick(@CTRow)
    verifyCTImageDisplayed
  end
  
  def verifyCTImageDisplayed
    ctImage = Element.new("CT Image", ":Form.qvtkWidget_QVTKWidget_3")
  end
  
  def openAndTimeCTScanImage(timer)
    timer.start
    openCTScan
    timer.stop
    return PlanScreen.new
  end
  
  private
  
  def getPlanRows
    rows = Array.new
    startIndex = 2
    
    begin
      begin
        # each patient plan row is indexed via the 'occurrence' property
        rowName = "{container=':Form.customTreeWidget_CustomTreeWidget' name='frame' occurrence='%s' type='QFrame' visible='1'}" % startIndex

        row = waitForObject(rowName, OBJECT_WAIT_TIMEOUT)
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
class Patient < BaseScreenObject
  attr_reader :name

  def initialize(name, objectString)
    @name = name
    @patientElement = Element.new(name, objectString)
  end
  
  # Returns the patient details (CT Row, Plan Rows)
  def openPatientDetails
    click(@patientElement)
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
class PatientTable < BaseScreenObject
  attr_reader :patientList

  def initialize
    @tableHeader = TableHeader.new
    @patientList = getPatientList
  end


  private

  # Returns the list of patients found within the container
  def getPatientList
    patientContainer = Element.new("Patient Table Container", ":Form.customTreeWidget_CustomTreeWidget")
    patientList = Array.new

    patientContainer.getChildren.each do |x|
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

