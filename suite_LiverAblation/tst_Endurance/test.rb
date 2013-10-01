# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "kermit_core\\Timer.rb")
require findFile("scripts", "screen_objects\\EditAblation.rb")
require findFile("scripts", "screen_objects\\EditTarget.rb")
require findFile("scripts", "screen_objects\\MainScreen.rb")
require findFile("scripts", "screen_objects\\PatientTable.rb")
require findFile("scripts", "screen_objects\\AddTargets.rb")
require findFile("scripts", "screen_objects\\WarningDialogPopup.rb")


#
# Upslope Endurance Test: 
#


def main

  startApplication("LiverAblation")

  # construct the main page
  mainScreen = MainScreen.new

  Test.log("Patient list size is :" + mainScreen.patientTable.getPatientCount.to_s)
  
  # For each patient in the patient table, create a plan, then delete it over a period of a day 
  mainScreen.getPatientList.each_with_index do |patient, index|
    
    # There are only MAX_NUM_VISIBLE_TABLE_ROWS visible rows on the Patient Table and Squish will not
    # automagically select a patient or plan. This script needs to scroll down
    # to the appropriate table row for Squish to select it
     
    # Scroll down to the patient (if necessary) and click on the patient to open details
    patientDetails = mainScreen.scrollToPatientIndex(index).openPatientDetails(patient)

    # Store the plan count for the patient
    origPlanCount = patientDetails.getPlanCount
  
    # Create a plan for the patient
    patientDetails.clickCreateNewPlan.clickAddTarget.clickAddAblationZone.clickAddAblation
    
    # Go back to load images screen
    mainScreen.clickLoadImagesRadio

    # Scroll down to the patient (if necessary) and verify new row created
    patientDetails = mainScreen.scrollToPatientIndex(index).openPatientDetails(patient)
    

    Test.verify(origPlanCount+1 == patientDetails.getPlanCount, "Verify Plan count increased by one")
    
    # Note the current row for the patient
    patientRowIndex = index % (MAX_NUM_VISIBLE_TABLE_ROWS - 1)
    Test.log("patientRowIndex: #{patientRowIndex}")
    
    newPlanCount = patientDetails.getPlanCount
    Test.log("New Plan count is " + newPlanCount.to_s)

    # Scroll down to the last plan row to delete it
    # +1 is for the CT row    
    mainScreen.scrollToPatientIndex(patientRowIndex + 1 + newPlanCount)

    # Delete the plan
    patientDetails.planRows.last.deletePlan

    # Open patient details to verify new row created
    patientDetails = patient.openPatientDetails
       
    # Verify the plan was deleted
    Test.verify(origPlanCount == patientDetails.getPlanCount, "Verify Plan count decreased by one")

    # CLick the row again to close patient details
    patient.closePatientDetails
  end



    # 1st child
      ## TEST CASE ##
      # For each patient, Check the CT for respective DICOM data on the load images screen...What data???
        #verify modalityLable exists and has text 'CT'
        #verify ratingLabel exists and verify x/5 stars (5 different images for each star rating)
        #verify info link to modal popup
        #verify 'Create New Plan' button
      
      ## TEST CASE
      #time how long it takes to load each DICOM image
      #save the snapshots???
      #output the times to a file for each patient
      
      ## TEST CASE
      # for each patient
        #click on 'Create New Plan', click on 'Add Target', click on 'Save Target', click on 'Save Ablation Zone'
          # click on 'Save Entry Point'
        # Click on 'Load Images' link and verify the plan was created for respective DICOM data
  

end
