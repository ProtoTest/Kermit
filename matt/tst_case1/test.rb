# encoding: UTF-8
require 'squish'
include Squish


require findFile("scripts", "MainPage.rb")
require findFile("scripts", "PatientTable.rb")


def main
  startApplication("LungAblation")
    
  # construct a page
  mainPage = MainPage.new
  
  patientContainer = PatientTable.new(":Form.customTreeWidget_CustomTreeWidget")
  patientObjList = patientContainer.patientList
  patientObjList.each do |x|
    Test.log(x.getProperty("text"))
    x.click
    snooze 1
  end
  
#  cElem = Element.new("{column='0' container=':Form.customTreeWidget_CustomTreeWidget' text='1.3.6.1.4.1.9328.50.3.0537' type='QModelIndex'}")
#  cElem.click()
  
#  plan = Element.new("{container=':Form.customTreeWidget_CustomTreeWidget' name='frame' type='QFrame' visible='1'}")
#  patient = waitForObjectItem(":Form.customTreeWidget_CustomTreeWidget", "3691393543", 2000)
#  
#  mouseClick(patient)
#  
#  firstRowContainer = waitForObject(":customTreeWidget.frame_QFrame", 2000)
#  # waitForObjectItem(":customTreeWidget.frame_QFrame", "Create New Plan", 2000) doesn't fucking work
#  doubleClick(firstRowContainer)
#  snooze(5)
#  mainPage.loadImagesButton.click
#  
  
#  :frame.Create New Plan_QPushButton
#  :frame.Open Plan_QPushButton
#  :frame.Open Plan_QPushButton_2
#  {container=':customTreeWidget.frame_QFrame_5' name='openPlanButton' text='Open Plan' type='QPushButton' visible='1'}
#  {container=':customTreeWidget.frame_QFrame_2' name='openPlanButton' text='Open Plan' type='QPushButton' visible='1'}
  # First row after patient click
  #Create new plan row:
    #:customTreeWidget.frame_QFrame
    #{container=':Form.customTreeWidget_CustomTreeWidget' name='frame' type='QFrame' visible='1'}
  #Open plan row: 
    # :customTreeWidget.frame_QFrame_4
      #{container=':Form.customTreeWidget_CustomTreeWidget' name='frame' occurrence='2' type='QFrame' visible='1'}
    # :customTreeWidget.frame_QFrame_5
      # {container=':Form.customTreeWidget_CustomTreeWidget' name='frame' occurrence='3' type='QFrame' visible='1'}
    # :customTreeWidget.frame_QFrame_3
      # {container=':Form.customTreeWidget_CustomTreeWidget' name='frame' occurrence='4' type='QFrame' visible='1'}
    # :customTreeWidget.frame_QFrame_2
      # {container=':Form.customTreeWidget_CustomTreeWidget' name='frame' occurrence='5' type='QFrame' visible='1'}
  
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
  
  
  # click some stuff
#  mainPage.patientNameHeaderView.click
#  mainPage.patientIDHeaderView.click
#  mainPage.birthDateHeaderView.click
#  mainPage.lastAccessHeaderView.click
  
#    mainPage.searchBox.enterText("I am searching")
#    snooze(2)
#    mainPage.searchBox.clear
#    mainPage.doShit(mainPage.patient0)
#    mainPage.captureScreenButton.click
#    
#  mainPage.patient0.click
#  Test.log("patient0 has children") if mainPage.patient0.hasChildren?
#  mainPage.patient0.printChildren
  
  
    
    
  #  mainPage.databaseButton.click
  #  mainPage.cdButton.click
  #  mainPage.usbButton.click
  #  mainPage.hardDriveButton.click
  #  mainPage.closeButton.click
end
