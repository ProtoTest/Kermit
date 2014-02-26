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

  # Run target test on one patient with 20 targets
  testTargets(MainScreen.new, patients_under_test[0,1], 20)
  
  #testSearchBox(patients_under_test)
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