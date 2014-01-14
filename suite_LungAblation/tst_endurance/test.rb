# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "kermit_core\\TestConfig.rb")
require findFile("scripts", "screen_objects\\MainScreen.rb")

#
# Upslope Endurance Test:
#
# iterationTimeLimit: The number of seconds to run the tests on each import source.
# sources: The sources to run the tests on. Valid values are :hdd, :cd, :usb.
#          :hdd corresponds to the DICOM folder in the upslope install directory.
#          :cd corresponds to a drive mounted at E:
#          :usb corresponds to a drive mounted at K:
# The test will do the following actions for each iteration:
#    1. Import the first CT series listed for each patient in the import source.
#    2. Create a plan, take a screenshot of the 3D preview, then delete the plan for the first 
#       CT series for each patient in System.
#    3. Delete each patient in the System.
#
# Test failures are recorded whenever an UI element does not appear on the screen within a timeout period.
# Test successes are recorded at key points in each iteration.
#
# After the test is complete, a HTML log file will be written to <user home>\Documents\SquishTestLogs
# which lists actions recorded throughout the test run including diagnostics, test success and test failures.
# Additional information regarding the execution environment and CPU and memory usage throughout the test 
# are included.
#
def runTest(iterationTimeLimit, sources)
  begin
    sources.each do | source |

      startTime = Time.now
      currentTime = Time.now
      iterationNumber = 1
      while currentTime - startTime < iterationTimeLimit do
        @@logFile.TestLog("Current elapsed time for tests on #{source}: #{(currentTime - startTime)/60} minutes")
        @@logFile.TestLog("STARTING ITERATION #{iterationNumber}")
        @@logFile.TestLog("Importing data from #{source}")
        MainScreen.new.importPatients(source)
        mainScreen = MainScreen.new
        mainScreen = mainScreen.Customer_Endurance_Loop
        @@logFile.TestLog("Clearing patient list")
        MainScreen.new.deletePatients
        @@logFile.TestLog("COMPLETED ITERATION #{iterationNumber}")
        iterationNumber += 1
        currentTime = Time.now
      end

    end
    completeTest
  rescue Exception => e
    @@logFile.TestFail("Endurance test failed: #{e.message}\n#{e.backtrace.inspect}")
    completeTest
  end
end
def main

  startApplication("LungAblation")

  # TestConfig
  installEventHandlers()

  # Run each import source test for 24 hours.
  runTest(24*60*60, [:hdd,:cd,:usb])


    # 1st child
      ## TEST CASE ##
      # For each patient, Check the CT for respective DICOM data on the load images screen...What data???
        #verify modalityLable exists and has text 'CT'
        #verify ratingLabel exists and verify x/5 stars (5 different images for each star rating)
        #verify info link to modal popup
        #verify 'Create New Plan' button

      ## TEST CASE
      #time how long it takes to load each DICOM image
      #save the snapshots???
      #output the times to a file for each patient

      ## TEST CASE
      # for each patient
        #click on 'Create New Plan', click on 'Add Target', click on 'Save Target', click on 'Save Ablation Zone'
          # click on 'Save Entry Point'
        # Click on 'Load Images' link and verify the plan was created for respective DICOM data


  end
