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
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")
require findFile("scripts", "screen_objects\\AppHeaderFooter.rb")
require findFile("scripts", "screen_objects\\PatientTable.rb")

#
# TODO: create functionality to load images via, CD, USB, HDD
#
class MainScreen < BaseScreenObject
  attr_reader :patientTable
  
  def initialize
    # check for the out of memory popup
    if popupOnScreen?
      @popup.clickBtn("OK")
    end

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
  
  
  ###########################
  #This function is used to loop through and run an endurance test.  This only iterates once. 
  #We might want to break this out into separate screen object calls.
  ###########################
  def Customer_Endurance_Loop
    @patientTable.patientList.each_with_index do |patient, index|
      #Scroll the the index of the patient, used if the patient index it outside the bounds of the scroll window
      @patientTable.scrollToRowByIndex(index)
      #Get the patient details
      details = patient.openPatientDetails
      #Get the number of plans from the patient record
      origPlanCount = details.getPlanCount
      #Add a new plan for the selected patient record
      details.clickCreateNewPlan.clickAddTarget.clickAddAblationZones.clickAddAblation 
      #Go back to the patient tree
      @appHeaderFooter.clickLoadImagesRadio
      #Scroll to the patient (if needed) and open up the patient details - displaying all the available plans for this patient
      details = scrollToPatientIndex(index).openPatientDetails(patient)
      #Test to make sure that the original plan count is increased by one
      @@logFile.TestVerify(origPlanCount+1 == details.getPlanCount, "Verify Plan count increased by one")		
      #Determine the patient row index for the new plan
      patientRowIndex = index % (MAX_NUM_VISIBLE_TABLE_ROWS - 1)

      @@logFile.Trace("patientRowIndex: #{patientRowIndex}")
      newPlanCount = details.getPlanCount
      @@logFile.Trace("New Plan count is " + newPlanCount.to_s)		
      # Scroll down to the last plan row to delete it
      # +1 is for the CT row    
      scrollToPatientIndex(patientRowIndex + 1 + newPlanCount)
      # Delete the plan
      details.planRows.last.deletePlan		
      # Open patient details to verify new row created
      details = patient.openPatientDetails        
      # Verify the plan was deleted
      @@logFile.TestVerify(origPlanCount == details.getPlanCount, "Verify Plan count decreased by one")
      # CLick the row again to close patient details
      patient.closePatientDetails
    end
  return MainScreen.new
end
  
  def searchforRecord(searchText)
    @searchField.enterText(searchText)
    return MainScreen.new
  end  
   
   
  def clickPatient(patientName)
    patient = nil
   @patientTable.patientList.each do |x|
     if x.name == patientName
       patient = x
       break
     end
   end
   
   if patient.nil?
     @@logFile.TestFail("Failed to find patient " + patientName)
     return nil
   else
     return patient.openPatientDetails
   end
  end 
  

  def getPatientList
    return @patientTable.patientList
  end

  def scrollToPatientIndex(index)
    @patientTable.scrollToRowByIndex(index)
    return MainScreen.new
  end

  def openPatientDetails(patient)
    return patient.openPatientDetails
  end
end