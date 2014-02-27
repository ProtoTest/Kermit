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

  testImageCount(MainScreen.new, patients_under_test[1,1])
  
  # Run target test on one patient with 20 targets
  #testTargets(MainScreen.new, patients_under_test[0,1], 20)
  
  #testSearchBox(patients_under_test)
end

# Requires the external ruby configuration properly set, and the external ruby must have chunky_png installed.
# Verifies that the number of images specified in each patient's first listed CT Series matches the number of images
# in the plan creator view.  It does this by scrolling down to the bottom of the image slider in the upper right of the screen,
# then scrolling up (number of images)/2 times and verifies that the green slider line is in the center of the slider.
#
# Parameters: mainScreen - the initialized MainScreen object.
#             patients_list - a list of patient id's to run the test on.
def testImageCount(mainScreen, patients_list)
  mainScreen.getPatientList.each do |patient|
    if patients_list.include?(patient.id)
      details = patient.openPatientDetails
      Log.TestLog("#{details.CTRow.getImageCount.class.name}")
      
      imageCount = Integer(details.CTRow.getImageCount.to_s.split[0])
      addTargetsScreen = details.clickCreateNewPlan
      addTargetsScreen.imageArea.click
      # fails if the images label says there are 20 more images than actually present.
      for n in (0..((imageCount/2)+10))
        nativeType("<PageDown>") 
      end
      for n in (0..(imageCount/2))
        nativeType("<PageUp>") 
      end

      pixelColor = addTargetsScreen.imageArea.getPixelColor([0,113]).to_i
      Log.TestVerify(IMAGE_SLIDER_COLORS.include?(pixelColor), "Green line is in the center of the image slider (Checking that #{pixelColor} is in #{IMAGE_SLIDER_COLORS}")

      addTargetsScreen.clickLoadImages
      mainScreen.deletePatientPlans(patient.id)
    end
  end
end

def testTargets(mainScreen, patients_list, targetsPerPatient)
  Log.TestLog("#{mainScreen.getPatientList}")
  mainScreen.getPatientList.each_with_index do |patient, index|
    Log.TestLog("Running loop!")
    if patients_list.include?(patient.id)
      Log.TestLog("Testing creation of ${targetsPerPatient} targets for patient ${patient.id}")
      begin
        addTargetsScreen = patient.openPatientDetails.clickCreateNewPlan
        addTargets(addTargetsScreen, targetsPerPatient)
      rescue Exception => e
        Log.TestFail("Creation of targets failed for patient #{patient.id}: #{e.message}")
      ensure
        mainScreen = MainScreen.new
        mainScreen.deletePatientPlans(patient.id)
      end
    end
  end
end

def addTargets(add_targets_screen, count)
  begin
    (1..count).each do | n |
      targetName = "target#{n}"
      add_targets_screen.addTarget(targetName, "Note: ${targetName}")
      add_targets_screen = add_targets_screen.clickVisualize
      Log.TestLog("Verifying #{targetName}")
      add_targets_screen.clickTargetTabByName(targetName)
      add_targets_screen.clickVisualize
    end
  ensure
    add_targets_screen.clickLoadImages
  end
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