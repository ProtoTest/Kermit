# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "EditTargetScreen.rb")
require findFile("scripts", "EditAblationScreen.rb")
require findFile("scripts", "SetEntryPointScreen.rb")
require findFile("scripts", "TargetDetailsScreen.rb")
require findFile("scripts", "MainScreen.rb")
require findFile("scripts", "PatientTable.rb")
require findFile("scripts", "Timer.rb")



def main
  startApplication("LungAblation")
  
  # construct a page
  mainScreen = MainScreen.new

  Test.log("Patient list size is :" + mainScreen.patientTable.patientList.size.to_s)
  
  # Store all the times to load CT images
  loadCTTimeArray = Array.new
  
  # Create a timer
  myTimer = Timer.new

 #  For each patient in the patient table, load up the CT and time how long it takes.
  mainScreen.patientTable.patientList.each do |patient|
    #loadCTTimeArray << ["Disk^39", mainScreen.clickPatient("DISK^39").openAndTimeCTScanImage(myTimer)]
    patient.openPatientDetails.openAndTimeCTScanImage(myTimer).clickAddTarget.clickSaveTarget.clickSaveAblation.clickSaveEntryPoint
    loadCTTimeArray << [patient.name, myTimer.elapsed]
    
    mainScreen.clickLoadImagesRadio
    
  end

  loadCTTimeArray.each do |x|
    Test.log("CT Load Time: " + x.to_s)
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
