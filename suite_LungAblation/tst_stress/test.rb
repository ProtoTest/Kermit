# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "kermit_core\\TestConfig.rb")
require findFile("scripts", "kermit_core\\Timer.rb")
require findFile("scripts", "screen_objects\\MainScreen.rb")


def main
  startApplication("LungAblation")

  # TestConfig
  installEventHandlers()

  # construct a page
  mainScreen = MainScreen.new

  Test.log("Patient list size is :" + mainScreen.patientTable.patientList.size.to_s)

  # Store all the times to load CT images
  loadCTTimeArray = Array.new

  # Create a timer
  myTimer = Timer.new

 #  For each patient in the patient table, load up the CT and time how long it takes.
  mainScreen.getPatientList.each_with_index do |patient, index|
    # scroll down to the patient index (if necessary)
    mainScreen.patientTable.scrollToRowByIndex(index)

    # open the ct scan and time it
    patient.openAndTimeCTScanImage(myTimer).clickLoadImages

    loadCTTimeArray << [patient.name, myTimer.elapsed]
    Log.TestLog("CT Load Time: " + loadCTTimeArray.last.to_s)

    Log.TestLog("Cleanup and delete the plan")
    #Scroll to the patient (if needed) and open up the patient details - displaying all the available plans for this patient
    patientDetails = mainScreen.scrollToPatientIndex(index).openPatientDetails(patient)
    #Determine the patient row index for the new plan
    patientRowIndex = index % (MAX_NUM_VISIBLE_TABLE_ROWS - 1)

    # Scroll down to the last plan row to delete it
    # +1 is for the CT row
    newPlanCount = patientDetails.getPlanCount
    mainScreen.scrollToPatientIndex(patientRowIndex + 1 + newPlanCount)
    # Delete the plan
    patientDetails.planRows.last.deletePlan
  end

  Log.TestLog("TEST COMPLETED... Outputting CT Scan load times for each patient")

  loadCTTimeArray.each do |x|
    Log.TestLog("CT Load Time: " + x.to_s)
  end

  # test is Done!
  completeTest

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
