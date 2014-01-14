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

    if objectChildren
      # For elements whose text changes, need to use the real object name
      @icon = Element.new("Row Icon Label", ObjectMap.symbolicName(objectChildren[1]))
      @type = Element.new("Row_Type_Label", ObjectMap.symbolicName(objectChildren[2]))
      @date = Element.new("Date Label", ObjectMap.symbolicName(objectChildren[3]))
      @imageCountLabel = Element.new("Image Count Label", "{container=':customTreeWidget.frame_QFrame' name='dateLabel' type='QLabel' visible='1'}")
      @compatibilityLabel = Element.new("Compatibility Label", ObjectMap.symbolicName(objectChildren[5]))
      @ratingLabel = Element.new("Rating Label", ObjectMap.symbolicName(objectChildren[6]))
      @createPlanButton = Element.new("Create New Plan Button", ObjectMap.symbolicName(objectChildren[7]))
    end
  end

  # override base class dClick. Doing this b/c the test to time opening the CT scan
  # is wasting ~1000+ milliseconds on moving the mouse to click on the center of the row
  def dClick
    # double click the date label instead
    @date.dClick
  end

  def saveCompatibilitySnapshot(filename)
    @compatibilityLabel.click
    screenshotButton = Element.new("ScreenShot Button","{name='captureScreenButton' type='QPushButton' visible='0' window=':CompatibilityDialog_CompatibilityDialog'}")
    screenshotButton.click
    ScreenCapturePopup.new.saveScreenshot(filename)
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

  # Deletes the plan
  def deletePlan
    self.click

    # Send the Delete key
    type(waitForObject(self.symbolicName), "<Delete>")
    snooze 1

    # Select the 'Delete' button from the warning dialog
    popup = WarningDialogPopup.new
    popup.clickBtn("Delete")
  end

  # Opens up the plan
  def openPlan
    @openPlanButton.click
  end
end


########################################################################################
#
#  Patient Details
#     Stores the object elements for a Patient's CT and plan rows
#
#     Does not currently handle multiple CT rows.
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
    Log.Trace(@CTRow.createPlanButton.to_s)
    Log.Trace(@CTRow.createPlanButton.onScreen?.to_s)
    @CTRow.createPlanButton.click
	  return AddTargets.new
  end

  # Double clicks the patient's CT scan to open it
  def openCT(timer=nil)
    timer.start if not timer.nil?
    @CTRow.dClick
    timer.stop if !timer.nil? && CTImageDisplayed?
  end

  # Verifies the CT image is displayed
  def CTImageDisplayed?
    begin
      waitForObject(":Form.qvtkWidget_QVTKWidget", OBJECT_WAIT_TIMEOUT)
      return true
    rescue Exception => e
      return false
    end
  end

  # Returns the count of plans for the patient
  def getPlanCount
    return @planRows.size
  end


############################### PRIVATE FUNCTIONALITY ####################################

  private

  # Returns an array of the plan rows for the patient
  def getPlanRows
    rows = Array.new
    startIndex = 2

    begin
      begin
        # each patient plan row is indexed via the 'occurrence' property
        rowName = "{container=':Form.customTreeWidget_CustomTreeWidget' name='frame' occurrence='%s' type='QFrame'  visible='1'}" % startIndex

        row = waitForObject(rowName, 500)
        rows << PlanRow.new(rowName)
        startIndex += 1

      end while (1)
    rescue Exception => e
      # don't care, this is used as the condition to break from the while
    end

    Log.Trace("#{self.class.name}::#{__method__}(): Found #{rows.size} plan rows")
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
  attr_reader :name, :id, :birthDate, :lastAccessed

  def initialize(patient_info_array, objectString)
    @name = patient_info_array[0]
    @id = patient_info_array[1]
    @birthDate = patient_info_array[2]
    @lastAccessed = patient_info_array[3]

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
  end

  # Opens up the patient's CT
  def openCTScan(timer=nil)
    openPatientDetails.openCT(timer)
  end

  # Opens up the patient's CT and times how long it takes to open it
  # Param: timer - the timer used to time request
  def openAndTimeCTScanImage(timer)
    openCTScan(timer)
    return AddTargets.new
  end

  def deletePatient
    @patientElement.click
    # Rather than instantiate PatientDetails, just select the ctrow directly.
    ctrow = CTRow.new("{container=':Form.customTreeWidget_CustomTreeWidget' name='frame' type='QFrame' visible='1'}")
    ctrow.click
    type(waitForObject(ctrow.symbolicName), "<Delete>")
    # Select the 'Delete' button from the warning dialog
    popup = WarningDialogPopup.new
    popup.clickBtn("Delete")
  end

  def to_s
    "Patient = [name:#{@name}, id:#{@id}, birthDate:#{@birthDate}, lastAccessed:#{@lastAccessed}]"
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

  def scrollDown
    @scrollbar.scrollDown if @scrollbar.onScreen?
  end

  # scroll down to row in the table
  def scrollToRowByIndex(index)
	  Log.Trace("Scrolling down to index: #{index}")
	  Log.Trace("Scrolling #{(index/(MAX_NUM_VISIBLE_TABLE_ROWS-1)).to_i} times")
    if(index >= (MAX_NUM_VISIBLE_TABLE_ROWS-1))
      (index / (MAX_NUM_VISIBLE_TABLE_ROWS-1)).to_i.times do
        @scrollbar.scrollDown
      end
    end
  end

  def deletePatient(index)
    @patientList[index].deletePatient
    @patientList.delete_at(index)
  end

  # Returns the number of patients in the patient table
  def getPatientCount
    return @patientList.size
  end

############################### PRIVATE FUNCTIONALITY ####################################

  private

  # Returns the list of patients(Class.Patient) found within the container
  def getPatientList
    patientContainer = Element.new("Patient Table Container", ":Form.customTreeWidget_CustomTreeWidget")
    patientList = Array.new

    if children=patientContainer.getChildren
      children.each_with_index do |x, index|
        # if the colum is 0, then it is the patient name
        if x.respond_to?(:text) and x.respond_to?(:column) and (x.column==0)
          # If we are dynamically adding patients after they are loaded, the patient objects
          # need to be added to the Object Map
          # begin


          # Grab the patient ID, birthdate, last accessed and store it in the patient list. They are the
          # successive children after we found the patient name, which is 'x'
          patientID = children[index+1]
          birthdate = children[index+2]
          lastAccessed = children[index+3]
          # Assume we have never seen this patient before and add its element's symbolic name to Squish's object map.
          ObjectMap.add(patientID)
          patientList << Patient.new([x.text, patientID.text, birthdate.text, lastAccessed.text], ObjectMap.symbolicName(patientID))
        end
      end
    else
      Log.TestFail("#{self.class.name}::#{__method__}(): Failed to find any patients in the table")
    end

    return patientList
  end
end

