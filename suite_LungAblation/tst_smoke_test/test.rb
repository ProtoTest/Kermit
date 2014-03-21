# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "kermit_core\\TestConfig.rb")
require findFile("scripts", "screen_objects\\MainScreen.rb")


def main
  # Patients from the sample data installer.
  patients_under_test = ['1.3.6.1.4.1.9328.50.1.0072', '1.3.6.1.4.1.9328.50.3.0537', '44444', 'MR15124', 'LIDC-IDRI-0031', 'LIDC-IDRI-0072', 'LIDC-IDRI-0118']
  
  
  startApplication("LungAblation")

  # TestConfig
  installEventHandlers()

  patients_smoke_test(MainScreen.new, patients_under_test)
  
  # Run target test on one patient with 20 targets
  #testTargets(MainScreen.new, patients_under_test[0,1], 20)
  
  #testSearchBox(patients_under_test)
end

def patients_smoke_test(main_screen, patient_id_list)
  main_screen.getPatientList.each do |patient|
    next if ! patient_id_list.include?(patient.id)
    testExportImages(main_screen, patient)
    testImageCount(main_screen, patient)
    testTabCount(main_screen, patient, TABS_TO_CREATE)
    testStarExists(main_screen, patient)
    testCrud(main_screen, patient)
  end
end

# Requires the external ruby configuration properly set, and the external ruby must have chunky_png installed.
# Verifies that the number of images specified in each patient's first listed CT Series matches the number of images
# in the plan creator view.  It does this by scrolling down to the bottom of the image slider in the upper right of the screen,
# then scrolling up (number of images)/2 times and verifies that the green slider line is in the center of the slider.
#
# Parameters: mainScreen - the initialized MainScreen object.
#             patients_list - a list of patient id's to run the test on.
def testImageCount(mainScreen, patient)
  details = patient.openPatientDetails
  Log.TestLog("#{details.patientCTPlans.first.ct.getImageCount.class.name}")
  
  imageCount = Integer(details.patientCTPlans.first.ct.getImageCount.to_s.split[0])
  addTargetsScreen = details.clickCreateNewPlan
  addTargetsScreen.imageArea.click
  # fails if the images label says there are 20 more images than actually present.
  for n in (0..(imageCount/2))
    nativeType("<PageDown>") 
  end
  Test.vp("image_slider_bottom")
  for n in (0..(imageCount/2))
    nativeType("<PageUp>") 
  end
  
  Test.vp("image_slider_centered")
  #pixelColor = addTargetsScreen.imageArea.getPixelColor([0,113]).to_i
  
  #Log.TestVerify(IMAGE_SLIDER_COLORS.include?(pixelColor), "Green line is in the center of the image slider (Checking that #{pixelColor} is in #{IMAGE_SLIDER_COLORS}")
  
  addTargetsScreen.clickLoadImages
  mainScreen.deletePatientPlans(patient.id)

end

def testTabCount(main_screen, patients, targets)

  Log.TestLog("Testing creation of ${targetsPerPatient} targets for patient ${patient.id}")
  begin
    add_targets_screen = patient.openPatientDetails.clickCreateNewPlan
    addTargets(addTargetsScreen, targets)
  rescue Exception => e
    Log.TestFail("Creation of targets failed for patient #{patient.id}: #{e.message}")
  ensure
    add_targets_screen.clickLoadImages
    main_screen = MainScreen.new
    main_screen.deletePatientPlans(patient.id)
  end
end

def addTargets(add_targets_screen, count)
  (1..count).each do | n |
    targetName = "target#{n}"
    add_targets_screen.addTarget(targetName, "Note: ${targetName}")
    add_targets_screen = add_targets_screen.clickVisualize
    Log.TestLog("Verifying #{targetName}")
    add_targets_screen.clickTargetTabByName(targetName)
    add_targets_screen.clickVisualize
  end
end

def testStarExists(main_screen, patient)
  patient.openPatientDetails.patientCTPlans.first.ct.click
  Test.vp("star_rating")
  patient.closePatientDetails
end

def randomUnicodeString(char_set, length)
  return Array.new(length) { char_set[rand(char_set.size)].chr('UTF-8') }.join()
end

def testCrud(main_screen, patient)
  add_targets = patient.openPatientDetails.clickCreateNewPlan
  edit_target = add_targets.addTarget(randomUnicodeString(UNICODE_DATAPOINTS, 20),randomUnicodeString(UNICODE_DATAPOINTS, 20))
  edit_ablation = edit_target.clickAddAblationZones.clickAddAblation
  edit_ablation.enterAblationZoneInfo(1+rand(2), 1+rand(3), 1+rand(3))
  edit_ablation.appHeaderFooter.clickLoadImagesRadio
  main_screen.deletePatientPlans(patient.id)
end
  

def testSearchBox(patients_list)
  mainScreen = MainScreen.new
  patients_list.each do |patient|
    Log.TestLog("Searching for patient #{patient}.")
    mainScreen = mainScreen.searchForRecord(patient)
    mainScreen = MainScreen.new
    patientsList = mainScreen.getPatientList
    sname = ":Form.customTreeWidget_CustomTreeWidget"
    Log.TestLog("#{Squish::Object.properties(waitForObject(sname))}")
    Log.TestLog("#{patientsList[1].getProperties}")
    Log.TestVerify(patientsList.count == 1, "Verify one unique result.")
    Log.TestVerify(patientsList[0].id == patient, "Verify the found patient matches #{patient}")
  end
end

def testExportImages(main_screen, patient)
  begin
     # construct the main application page
     main_screen = MainScreen.new
  
     add_targets_screen = main_screen.createPlanForPatientID(patient.id)
  
     # take all of the snapshots
     NUMBER_OF_SNAPSHOTS_TO_TAKE.times do
       add_targets_screen.appHeaderFooter.captureScreen(randomUnicodeString(UNICODE_DATAPOINTS, 20))
     end
  
     add_targets_screen.appHeaderFooter.clickExportRadio.exportToUSB.verifyExportSuccessful
  
   rescue Exception => e
     Log.TestFail("Export Images Test: #{e.message}\n#{e.backtrace.inspect}")
  ensure
    add_targets_screen.appHeaderFooter.clickLoadImagesRadio
  end  
end