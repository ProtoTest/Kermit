# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "kermit_core\\TestConfig.rb")
require findFile("scripts", "screen_objects\\MainScreen.rb")

#
# Upslope Endurance Test:
#
def runTest(iterations, sources)
  begin
    sources.each do | source |
      @@logFile.TestLog("Importing data from #{source}")
      MainScreen.new.importPatients(:hdd)
      iterations.times do |i|
        @@logFile.TestLog("STARTING ITERATION #{i}")
        mainScreen = MainScreen.new
        mainScreen = mainScreen.Customer_Endurance_Loop
        @@logFile.TestLog("COMPLETED ITERATION #{i}")
      end
      @@logFile.TestLog("Clearing patient list")
      MainScreen.new.deletePatients
    end
    completeTest
  rescue Exception => e
    @@logFile.TestFail("Endurance test failed: #{e.message}\n#{e.backtrace.inspect}")
    completeTest
  end
end


def main

  startApplication("LiverAblation")

  # TestConfig
  installEventHandlers()

  runTest(1, [:hdd,:cd,:usb])


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
