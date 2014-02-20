# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "kermit_core\\TestConfig.rb")


def main
  # Patients from the sample data installer.
  patients_under_test = ['1.3.6.1.4.1.9328.50.1.0072', '1.3.6.1.4.1.9328.50.3.0537', '44444', 'MR15124', 'LIDC-IDRI-0031', 'LIDC-IDRI-0072', 'LIDC-IDRI-0118']
  
  
  startApplication("LungAblation")

  # TestConfig
  installEventHandlers()

  testSearchBox(patients_under_test)
end

def testSearchBox(patients_list)
  mainScreen = MainScreen.new
  patients_list.each do |patient|
    Log.Trace("Searching for patient #{patient}.")
    mainScreen.searchForRecord(patient)
    patientsList = mainScreen.getPatientList
    Log.TestVerify(patientsList.count == 1, "Verify one unique result.")
    Log.TestVerify(patientsList[0].id == patient, "Verify the found patient matches #{patient}")
  end
end