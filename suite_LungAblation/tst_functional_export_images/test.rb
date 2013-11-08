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

  # construct the main application page
  main_screen = MainScreen.new
  main_screen.captureScreen("Matt_image", true).
  		searchForRecord("UN").
  		createPlanForPatientName("UNAVAILABLE").
  		captureScreen("Matt_image_2").
  		addTarget("Matt's target", "An awesome target note").
  		captureScreen("Matt_image_3", true).
      clickAddAblationZones.
      captureScreen("Matt_image_4").
      clickAddAblation.
      captureScreen("Matt_image_5").
      clickExport.
      captureScreen("Matt_image_6").
      ExportToUSB

      # TODO: Use ruby to open the exported folder of images and verify the image list count?

  snooze 5


  # test is Done!
  completeTest

end