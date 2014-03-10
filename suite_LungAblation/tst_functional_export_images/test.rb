# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "kermit_core\\TestConfig.rb")
require findFile("scripts", "screen_objects\\MainScreen.rb")

#
# Functional Test: Create a large set of images and export snapshots to USB drive
#
NUMBER_OF_SNAPSHOTS_TO_TAKE = 100

def main
  startApplication("LiverAblation")

  # TestConfig
  installEventHandlers()

  begin
    # construct the main application page
    main_screen = MainScreen.new

    patient_under_test = main_screen.getPatientList.first
    add_targets_screen = main_screen.createPlanForPatientName(patient_under_test.name)

    # take all of the snapshots
    NUMBER_OF_SNAPSHOTS_TO_TAKE.times do
      add_targets_screen.appHeaderFooter.captureScreen
    end

    add_targets_screen.appHeaderFooter.clickExportRadio.exportToUSB.verifyExportSuccessful

  rescue Exception => e
    Log.TestFail("Export Images Test: #{e.message}\n#{e.backtrace.inspect}")
  end

  # test is Done!
  completeTest

end