# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "kermit_core\\Element.rb")
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")
require findFile("scripts", "screen_objects\\AddTargets.rb")
require findFile("scripts", "screen_objects\\WarningDialogPopup.rb")

########################################################################################
#
#  Patient table header component
#     Stores object elements for the Patient table header
#
#  @author  Matt Siwiec
#  @notes 10/04/2013 - SU - Changed all BasePageObject clicks and dclicks to reference Element directly 
#
########################################################################################
class TableHeader < BaseScreenObject
  
  def initialize
    # Table Headers
    @patientNameHeaderView = Element.new("Patient Name Table Header", ":Patient Name_HeaderViewItem")
    @patientIDHeaderView = Element.new("Patient ID Table Header", ":Patient ID_HeaderViewItem")
    @birthDateHeaderView = Element.new("Birth Date Table Header", ":Birth Date_HeaderViewItem")
    @lastAccessHeaderView = Element.new("Last Accessed Table Header", ":Last Accessed_HeaderViewItem")
  end

  def clickPatientHeader
    @patientNameHeaderView.click
  end

  def clickPatientIDHeader
    @patientIDHeaderView.click	  
  end

  def clickBirthDateHeader
    @birthDateHeaderView.click
  end

  def clickLastAccessHeader
    @lastAccessHeaderView.click
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
  attr_reader :createPlanButton

  def initialize(objectString)
    super("PatientRow", objectString)
    
    #CT Row Children
      #QHboxLayout, iconLabel, modalityLabel(type), dateLabel, imageCountLabel, compatibilityLabel, ratingLabel, infoLabel(link), newPlanButton
    
    objectChildren = getChildren
    
    # For elements whose text changes, need to use the real object name
    @icon = Element.new("Row Icon Label", ObjectMap.symbolicName(objectChildren[1]))
    @type = Element.new("Row_Type_Label", ObjectMap.symbolicName(objectChildren[2]))
    @date = Element.new("Date Label", ObjectMap.symbolicName(objectChildren[3]))
    @imageCountLabel = Element.new("Image Count Label", "{container=':customTreeWidget.frame_QFrame' name='dateLabel' type='QLabel' visible='1'}")
    @compatibilityLabel = Element.new("Compatibility Label", ObjectMap.symbolicName(objectChildren[5]))
    @ratingLabel = Element.new("Rating Label", ObjectMap.symbolicName(objectChildren[6]))
    @infoLink = Element.new("Info Link", ObjectMap.symbolicName(objectChildren[7]))
    @createPlanButton = Element.new("Create New Plan Button", ObjectMap.symbolicName(objectChildren[8]))
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
    @byLabel = Element.new("Info Link", ObjectMap.symbolicName(objectChildren[4]))
    @byContentsLabel = Element.new("Info Link", ObjectMap.symbolicName(objectChildren[5]))
    @openPlanButton = Element.new("Button", ObjectMap.symbolicName(objectChildren[6]))    
  end  

  def deletePlan
    # click on the row
    self.click
    
    # Send the Delete key
    type(waitForObject(self.symbolicName), "<Delete>")
    snooze 1

    # Select the 'Delete' button from the warning dialog
    popup = WarningDialogPopup.new
    popup.clickBtn("Delete")
    return MainScreen.new
  end

  def openPlan
    @openPlanButton.click
    return AddTargets.new
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
#	10/04/2013 SethUrban Changed all clicks and dclicks to reference element instead of BasePageObject             
#
########################################################################################
class PatientDetails < BaseScreenObject
  attr_reader :CTRow, :planRows
  
  def initialize
    # using real name for squish here as the symbolic names differ across liver and lung applications
    @CTRow = CTRow.new("{container=':Form.customTreeWidget_CustomTreeWidget' name='frame' type='QFrame' visible='1'}")
    @planRows = getPlanRows 
  end
  
  # Clicks on the create new plan button 
  def clickCreateNewPlan
    @CTRow.createPlanButton.click
	  return AddTargets.new
  end

  # Double clicks the patient's CT scan to open it
  def openCT 
    @CTRow.dclick
    verifyCTImageDisplayed
  end
  
  def verifyCTImageDisplayed
    ctImage = Element.new("CT Image", ":Form.qvtkWidget_QVTKWidget_3")
  end

  def getPlanCount
    return @planRows.size
  end
  
  private
  
  def getPlanRows
    rows = Array.new
    startIndex = 2
    
    begin
      begin
        # each patient plan row is indexed via the 'occurrence' property
        rowName = "{container=':Form.customTreeWidget_CustomTreeWidget' name='frame' occurrence='%s' type='QFrame'  visible='1'}" % startIndex

        row = waitForObject(rowName, OBJECT_WAIT_TIMEOUT)
        rows << PlanRow.new(rowName)
        startIndex += 1
        
      end while (1)
    rescue Exception => e
      # don't care, this is used as the condition to break from the while
    end

    @@logFile.Trace("Found #{rows.size} plan rows")
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
#	10/04/2013 SethUrban Changed all clicks and dclicks to reference element instead of BasePageObject  
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
    @patientElement.click
    return PatientDetails.new
  end

  # Closes the tree for the patient
  def closePatientDetails
    @patientElement.click
    return MainScreen.new
  end

  def openCTScan
    openPatientDetails.openCT
    return AddTargets.new
  end

  def openAndTimeCTScanImage(timer)
    timer.start
    openCTScan
    timer.stop
    return AddTargets.new
  end
  
end


########################################################################################
#
#  PatientTable
#     Stores the components of all patients in the table
#
#  @author  Matt Siwiec
#  @notes 
#	10/04/13 - SU - Removed ScrollBar Class, changed to element class	
#
########################################################################################
class PatientTable < BaseScreenObject
  attr_reader :patientList

  def initialize
    @tableHeader = TableHeader.new
    @patientList = getPatientList
    @scrollbar = Element.new("Patient Table Scroll bar", ":customTreeWidget_QScrollBar")
  end

  # scroll down to row in the table
  def scrollToRowByIndex(index)
	  @@logFile.Trace("Scrolling down to index: #{index}")
	  @@logFile.Trace("Scrolling #{(index/(MAX_NUM_VISIBLE_TABLE_ROWS-1)).to_i} times")
    if(index >= (MAX_NUM_VISIBLE_TABLE_ROWS-1))
      (index / (MAX_NUM_VISIBLE_TABLE_ROWS-1)).to_i.times do
        @scrollbar.scrollDown
      end
    end
  end

  def getPatientCount
    return @patientList.size
  end



  private

  # Returns the list of patients(Class.Patient) found within the container
  def getPatientList
    patientContainer = Element.new("Patient Table Container", ":Form.customTreeWidget_CustomTreeWidget") 
    patientList = Array.new

    if children=patientContainer.getChildren 
      children.each do |x|
        if x.respond_to?(:text) and x.respond_to?(:column) and (x.column==0)
          # If we are dynamically adding patients after they are loaded, the patient objects
          # need to be added to the Object Map
          ObjectMap.add(x)
          patientList << Patient.new(x.text, ObjectMap.symbolicName(x))
        end
      end
    else
      @@logFile.TestFail("Where are the children?")
    end

    return patientList
  end
end

