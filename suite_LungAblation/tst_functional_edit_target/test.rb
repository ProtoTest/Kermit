# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "kermit_core\\TestConfig.rb")
require findFile("scripts", "screen_objects\\MainScreen.rb")


def main
  startApplication("LiverAblation")

  # TestConfig
  installEventHandlers()

  # construct a page
  mainScreen = MainScreen.new

  patient_under_test = "1.3.6.1.4.1.9328.50.1.0072"
  target_name = "Matt's Target"
  target_note = "As you can see here, automation entered a note for us"
  mainScreen = mainScreen.
    clickCreatePlanForPatient(patient_under_test).
    addTarget.
    deleteTarget.
    addTarget(target_name, target_note).
    clickLoadImages.
    openPlanForPatient(patient_under_test).
    clickTargetTabByName(target_name).
    verifyTargetInformation(target_name, target_note).appHeaderFooterEdit.clickLoadImagesRadio

  # cleanup, delete plan
  mainScreen.deletePlanForPatient(patient_under_test)

  # test is Done!
  completeTest

end

