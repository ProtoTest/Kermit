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

class MainScreen < BaseScreenObject
  attr_reader :patientTable
  
  def initialize
    # check for the out of memory popup
    if popupOnScreen?
      @popup.clickBtn("OK")
    end

    @searchField = Element.new("SearchField", ":Form.search_QLineEdit")
    @patientTable = PatientTable.new
    @appHeaderFooter = AppHeaderFooter.new

    @elements = [@searchField]
    verifyElementsPresent(@elements, self.class.name)
   
  end
  
  
  ###########################
  #This function will be used to gather all the patient info and must be called at the start of a test involving patients!
  ###########################
  def CustomerPatientLoop
	@patientTable.patientList.each_with_index do |patient, index|
		@patientTable.scrollToRowByIndex(index)
		details = patient.openPatientDetails
		origPlanCount = details.getPlanCount
		details.clickCreateNewPlan.clickAddTarget.clickAddAblationZone.clickAddAblation  #getting stuck here and thinking it's going back to the start of the loop
		clickLoadImagesRadio
		details = scrollToPatientIndex(index).openPatientDetails(patient)
		
		Test.verify(origPlanCount+1 == details.getPlanCount, "Verify Plan count increased by one")
		patientRowIndex = index % (MAX_NUM_VISIBLE_TABLE_ROWS - 1)
		Test.log("patientRowIndex: #{patientRowIndex}")
		newPlanCount = details.getPlanCount
		Test.log("New Plan count is " + newPlanCount.to_s)
		
		# Scroll down to the last plan row to delete it
		# +1 is for the CT row    
		scrollToPatientIndex(patientRowIndex + 1 + newPlanCount)

		# Delete the plan
		details.planRows.last.deletePlan
		
		# Open patient details to verify new row created
		details = patient.openPatientDetails
       
		# Verify the plan was deleted
		Test.verify(origPlanCount == details.getPlanCount, "Verify Plan count decreased by one")

		# CLick the row again to close patient details
		patient.closePatientDetails
	end
  end
  
  def searchforRecord(searchText)
    enterText(@searchField, searchText)
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
     Test.fail("Failed to find patient " + patientName)
     return nil
   else
     return patient.openPatientDetails
   end
  end 
  


  def clickLoadImagesRadio
    @appHeaderFooter.clickRadio(RadioButtons::LOAD_IMAGES)
    return MainScreen.new
  end

  def clickAddTargetsRadio
    @appHeaderFooter.clickRadio(RadioButtons::ADD_TARGETS)
  end

  def clickAddAblationZonesRadio
    @appHeaderFooter.clickRadio(RadioButtons::ADD_ABLATION)
  end

  def clickExportRadio
    @appHeaderFooter.clickRadio(RadioButtons::EXPORT)
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