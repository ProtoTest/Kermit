# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "kermit_core\\TestConfig.rb")
require findFile("scripts", "screen_objects\\MainScreen.rb")

#
# Functional Test: Verify 'Add/Delete Target' functionality
#   - Create a plan for patient 'x'
#   - Add a target
#   - Delete the target
#   - Add a target, enter a target name and note for the form
#   - Enter 'Load Images' screen
#   - Open the plan created for patient 'x'
#   - Verify the target created matches previously entered information
#   - Cleanup after the functional test by deleting the plan
#

def main
  startApplication("LiverAblation")

  # TestConfig
  installEventHandlers()

  # construct a page
  mainScreen = MainScreen.new

  patient_under_test = "1.3.6.1.4.1.9328.50.1.0072"
  target_name = "Matt's Target"

  begin
    mainScreen = mainScreen.
      createPlanForPatientName(patient_under_test).
      addTarget(target_name).
      addAblationZone.
      enterAblationZoneInfo(DoseTableOptions::LUNG, PowerOptions::WATTS_75, NeedleOptions::EMPRINT_30_CM).clickExport.appHeaderFooter.clickLoadImagesRadio

    # cleanup, delete plan

    mainScreen.deletePlanForPatientName(patient_under_test)
  rescue Exception => e
    Log.TestFail(e.message)
  end


  # test is Done!
  completeTest


end

