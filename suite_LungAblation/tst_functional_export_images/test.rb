# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "kermit_core\\TestConfig.rb")
require findFile("scripts", "screen_objects\\MainScreen.rb")

#
# Functional Test: Create and export snapshots to USB drive
#

def main
  startApplication("LiverAblation")

  # TestConfig
  installEventHandlers()

  begin
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
  rescue Exception => e
    Log.TestFail(e.message)
  end

      # TODO: Use ruby to open the exported folder of images and verify the image list count?
      
      # TODO: check for USB not plugged in popup and send notification to user to 
      # insert one and click continue

  snooze 5


  # test is Done!
  completeTest

end