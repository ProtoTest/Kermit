# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "kermit_core\\TestConfig.rb")
require findFile("scripts", "screen_objects\\MainScreen.rb")


def main
  # Patients from the sample data installer.
  patients_under_test = ['COVIDIEN','LIDC-IDRI-0001', 'LIDC-IDRI-0002', 'LIDC-IDRI-0008']
  
  # number of patients to import from each media source 
  load_count_from_media = 1
  
  
  startApplication("LungAblation")

  # TestConfig
  installEventHandlers()

  main_screen = MainScreen.new

  from_media_smoke_test(MainScreen.new, load_count_from_media)
  
  
  # Finalize the test run
  completeTest
end

def from_media_smoke_test(main_screen, load_count)
  [:hdd, :cd, :usb].each do | source |
    Log.Trace("Loading from #{source}")
    patients_under_test = main_screen.importPatients(source, load_count)
    Log.Trace("Loaded #{patients_under_test}")
    patient_ids = patients_under_test.map  { |patient| patient.id }
    Log.Trace("#{patient_ids}")
    patients_smoke_test(main_screen, patient_ids)
    main_screen.deletePatients(patients_under_test)
  end
end
  

def patients_smoke_test(main_screen, patient_id_list)
  Log.Trace("Testing #{patient_id_list}")
  main_screen = MainScreen.new
  main_screen.getPatientList.each do |patient|
    Log.Trace("Testing #{patient.id}")
    next if ! patient_id_list.include?(patient.id)
    Log.Trace("Images Count Test")
    testImageCount(main_screen, patient)
    Log.Trace("Tabs Test")
    testTabCount(main_screen, patient, TABS_TO_CREATE)
    Log.Trace("Export Test")
    testExportImages(main_screen, patient)
    Log.Trace("Stars Test")
    testStarExists(main_screen, patient)
    Log.Trace("Crud Test")
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
  imageCount = Integer(details.patientCTPlans.first.ct.getImageCount.to_s.split[0])
  addTargetsScreen = details.clickCreateNewPlan
  addTargetsScreen.imageArea.click
  for n in (0..(imageCount/2))
    nativeType("<PageDown>") 
  end
  Test.vp("image_slider_bottom")
  for n in (0..(imageCount/2))
    nativeType("<PageUp>") 
  end
  
  Test.vp("image_slider_centered")
  
  addTargetsScreen.clickLoadImages
  mainScreen.deletePatientPlans(patient.id)
  patient.closePatientDetails

end

def testTabCount(main_screen, patient, targets)

  Log.TestLog("Testing creation of ${targetsPerPatient} targets for patient ${patient.id}")
  begin
    add_targets_screen = patient.openPatientDetails.clickCreateNewPlan
    addTargets(add_targets_screen, targets)
  rescue Exception => e
    Log.TestFail("Creation of targets failed for patient #{patient.id}: #{e.message}")
  ensure
    main_screen.appHeaderFooter.clickLoadImagesRadio
    main_screen = MainScreen.new
    main_screen.deletePatientPlans(patient.id)
    patient.closePatientDetails
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
  Log.Trace("checking ratings on #{patient.id}")
  details = patient.openPatientDetails
  details.patientCTPlans.first.ct.click
  Test.vp("star_rating")
  patient.closePatientDetails
end

def randomUnicodeString(char_set, length)
  return Array.new(length) { char_set[rand(char_set.size)].chr('UTF-8') }.join()
end

def testCrud(main_screen, patient)
  Log.Trace("1")
  add_targets = patient.openPatientDetails.clickCreateNewPlan
  Log.Trace("2")

  edit_target = add_targets.addTarget(randomUnicodeString(UNICODE_DATAPOINTS, 20),randomUnicodeString(UNICODE_DATAPOINTS, 20))
  edit_ablation = edit_target.clickAddAblationZones.clickAddAblation
  edit_ablation.enterAblationZoneInfo(1+rand(2), 1+rand(3), 1+rand(3))
  edit_ablation.appHeaderFooter.clickLoadImagesRadio
  main_screen.deletePatientPlans(patient.id)
  patient.closePatientDetails

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
     Log.Trace("Testing large number of screenshots for patient #{patient.id}")
     add_targets_screen = patient.openPatientDetails.clickCreateNewPlan
       
     # take all of the snapshots
     NUMBER_OF_SNAPSHOTS_TO_TAKE.times do
       add_targets_screen.appHeaderFooter.captureScreen(randomUnicodeString(UNICODE_DATAPOINTS, 20))
     end
  
     add_targets_screen.appHeaderFooter.clickExportRadio.exportToUSB.verifyExportSuccessful
  
   rescue Exception => e
     Log.TestFail("Export Images Test: #{e.message}\n#{e.backtrace.inspect}")
  ensure
    main_screen.appHeaderFooter.clickLoadImagesRadio
  end  
end