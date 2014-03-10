# encoding: UTF-8
require 'squish'
include Squish

########################################
# Seth Urban
# This is the main screen object child class of the BaseScreenObject
# It will contain all the things displayed on the main entry page.
#########################################
# encoding: UTF-8
require findFile("scripts", "kermit_core\\Element.rb")
require findFile("scripts", "kermit_core\\Common.rb")
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")
require findFile("scripts", "screen_objects\\AppHeaderFooter.rb")
require findFile("scripts", "screen_objects\\PatientTable.rb")
require findFile("scripts", "screen_objects\\ScreenCapturePopup.rb")

#
# TODO: create functionality to load images via, CD, USB, HDD
#
class MainScreen < BaseScreenObject
  attr_reader :patientTable, :appHeaderFooter

  def initialize
    @searchField = Element.new("SearchField", ":Form.search_QLineEdit")
    @systemBtn = Element.new("System Button", ":Form.System_QToolButton")
    @cdBtn = Element.new("CD Button", ":Form.CD_QToolButton")
    @usbBtn = Element.new("USB Button", ":Form.USB_QToolButton")
    @hddBtn = Element.new("Hard Drive Button", ":Form.Hard Drive_QToolButton")

    @patientTable = PatientTable.new
    @appHeaderFooter = AppHeaderFooter.new

    @elements = [@searchField, @systemBtn, @cdBtn, @usbBtn, @hddBtn]
    verifyElementsPresent(@elements, self.class.name)

  end

  # Clicks on the Capture Screen button in the application header,sets the filename, and whether
  # to include the patient details in the capture
  # Params: filename - optional filename to give the screenshot
  #         hidePatientDetails - to hide the patient information or not (defaults to not hiding patient details)
  def captureScreen(filename=nil, hidePatientDetails=false)
    @appHeaderFooter.captureScreen(filename, hidePatientDetails)
    return self
  end

  ###########################
  #This function is used to loop through and run an endurance test.  This only iterates once.
  #We might want to break this out into separate screen object calls.
  ###########################
  def Customer_Endurance_Loop
    getPatientList.each_with_index do |patient, index|
      Log.Trace("Creating plan for patient id #{patient.id}")
      #Scroll the the index of the patient, used if the patient index it outside the bounds of the scroll window
      @patientTable.scrollToRowByIndex(index)
      #Get the patient details
      details = patient.openPatientDetails
      #Get the number of plans from the patient record
      origPlanCount = details.getPlanCount
      #Add a new plan for the selected patient record
      begin
        editScreen = details.clickCreateNewPlan.addTarget.clickAddAblationZones.clickAddAblation
      rescue
        # Some interaction between Squish and the Upslope application cause some patients not to open correctly.
        Log.TestFail("Plan editor for patient id #{patient.id} did not open.")
        @appHeaderFooter.clickLoadImagesRadio
        next
      end

      editScreen.capture3dScreenshot("Took 3D screenshot for patient name: #{patient.name} id: #{patient.id}", patient.id)
      #Go back to the patient tree
      @appHeaderFooter.clickLoadImagesRadio
      #Scroll to the patient (if needed) and open up the patient details - displaying all the available plans for this patient
      details = scrollToPatientIndex(index).openPatientDetails(patient)
      #Test to make sure that the original plan count is increased by one
      Log.TestVerify(origPlanCount+1 == details.getPlanCount, "Verify Plan count increased by one")
      #Determine the patient row index for the new plan
      patientRowIndex = index % (MAX_NUM_VISIBLE_TABLE_ROWS - 1)

      Log.Trace("#{self.class.name}::#{__method__}(): patientRowIndex: #{patientRowIndex}")
      newPlanCount = details.getPlanCount
      Log.Trace("#{self.class.name}::#{__method__}(): New Plan count is " + newPlanCount.to_s)
      # Scroll down to the last plan row to delete it
      # +1 is for the CT row
      scrollToPatientIndex(patientRowIndex + 1 + newPlanCount)
      # Delete the plan
      details.planRows.first.deletePlan
      # Open patient details to verify new row created
      details = patient.openPatientDetails
      # Verify the plan was deleted
      Log.TestVerify(origPlanCount == details.getPlanCount, "Verify Plan count decreased by one")
      # CLick the row again to close patient details
      patient.closePatientDetails
    end

    return MainScreen.new
  end

  # Import the first CT series for each patient in the import source.
  # Valid sources are :hdd, :cd, :usb.
  def importPatients(source)
    begin
      sourceBtn = getImportSourceBtn(source)
      sourceBtn.click

      # The patient table can take a while to load when large amounts of data is present.
      waitForPatientList
      # Once the table is on the screen we can finally read it.
      importScreen = MainScreen.new
      patientList = importScreen.getPatientList
      @systemBtn.click
      (0...patientList.size).each do |index|
        # Don't reload the patient list each time, as it can take a while with a long list.
        sourceBtn.click
        # We need to re-wait each time we return to the import source patient table
        # since it isn't cached by Upslope.
        waitForPatientList
        importScreen.patientTable.scrollToRowByIndex(index)
        patient = patientList[index]
        details = patient.openPatientDetails
        # Double clicking on a CT row triggers Upslope to import that CT series to the System patient table.
        # This currently only imports one CT series, but patients can have multiple series.
        # TODO - do we need to import every CT series?
        details.CTRow.dClick
      end
      Log.TestLog("Imported #{patientList.size} patients")
    rescue Exception => e
      Log.TestFail("Failed to import patients: #{e.message}")
    end
  end

  # Delete all patients from the System patient table.
  def deletePatients
    begin
      # Delete the first patient in the table repeatedly for the total patient count.
      patientCount = getPatientList.size
      (0...patientCount).each do |i|
        @patientTable.deletePatient(0)
      end
      Log.TestLog("Deleted #{patientCount} patients")
    rescue Exception => e
      Log.TestFail("Failed to delete patients: #{e.message}")
    end
  end

  # Enters the search text into to the search text box
  # Param: searchText - Text to search for
  def searchForRecord(searchText)
    @searchField.enterText(searchText)
    return MainScreen.new
  end

  # Returns the list of patients in the table
  def getPatientList
    return @patientTable.patientList
  end

  # Scroll down to the index in the patient table
  # Param: index - the row in the table (zero-based indexing)
  def scrollToPatientIndex(index)
    @patientTable.scrollToRowByIndex(index)
    return self
  end

  # Click on the patient to open up their CT/Plan details
  # Param: patient - patient object
  def openPatientDetails(patient)
    return patient.openPatientDetails
  end

  # Click on the patient in the patient table and open the first plan
  # Param: patientName - Patient name string
  def openPlanForPatientName(patientName)
    clickPatientByName(patientName).planRows.first.openPlan
    return AddTargets.new
  end

  # Click on the patient in the patient table and open the first plan
  # Param: patientID - Patient ID string
  def openPlanForPatientID(patientID)
    clickPatientByID(patientID).planRows.first.openPlan
    return AddTargets.new
  end

  # Click on the patient in the patient table and delete the first plan
  # Param: patientName - Patient name string
  def deletePlanForPatientName(patientName)
    clickPatientByName(patientName).planRows.first.deletePlan
  end

  # Click on the patient in the patient table and delete the first plan
  # Param: patientID - Patient ID string
  def deletePlanForPatientID(patientID)
    clickPatientByID(patientID).planRows.first.deletePlan
  end

  # Click on the patient in the patient table and create a plan
  # Param: patientName - Patient name string
  def createPlanForPatientName(patientName)
    return clickPatientByName(patientName).clickCreateNewPlan
  end

  # Click on the patient in the patient table and create a plan
  # Param: patientID - Patient ID string
  def createPlanForPatientID(patientID)
    return clickPatientByID(patientID).clickCreateNewPlan
  end

  def deletePatientPlans(patientID)
    details = clickPatientByID(patientID)
    while (details.getPlanCount > 0)
      details.planRows.first.deletePlan
      details = clickPatientByID(patientID)
    end
  end



  ###################################### PRIVATE FUNCTIONALITY ##################################
  private

  # Click on the patient in the patient table
  # Param: patientName - Patient name string
  def clickPatientByName(patientName)
    patient = nil
    @patientTable.patientList.each_with_index do |x, index|
      if x.name == patientName
        patient = x
        scrollToPatientIndex(index)
        break
      end
    end

    if patient.nil?
      raise "#{self.class.name}::#{__method__}(): Failed to find patient name: #{patientName} "
    else
      return patient.openPatientDetails
    end
  end

  # Click on the patient in the patient table
  # Param: patientID - Patient ID string
  def clickPatientByID(patientID)
    patient = nil
    @patientTable.patientList.each_with_index do |x, index|
      if x.id == patientID
        patient = x
        scrollToPatientIndex(index)
        break
      end
    end

    if patient.nil?
      raise "#{self.class.name}::#{__method__}(): Failed to find patient ID: #{patientID} "
    else
      return patient.openPatientDetails
    end
  end

  def getImportSourceBtn(source)
    case source
    when :hdd then return @hddBtn
    when :cd then  return @cdBtn
    when :usb then return @usbBtn
    end
  end

  def waitForPatientList
    patientContainer = Element.new("Patient Table Container", ":Form.customTreeWidget_CustomTreeWidget")
    # Should be 6, rather than 10, I think.
    waitFor('patientContainer.getChildren.size > 10', 90 * 1000)
    return self
  end

end