# encoding: UTF-8
require 'squish'
include Squish


require findFile("scripts", "MainPage.rb")




def main
  startApplication("LungAblation")
    
  # construct a page
  mainPage = MainPage.new
  
  # click some stuff
#  mainPage.patientNameHeaderView.click
#  mainPage.patientIDHeaderView.click
#  mainPage.birthDateHeaderView.click
#  mainPage.lastAccessHeaderView.click
  
  mainPage.doShit(mainPage.patient0)
  
  mainPage.patient0.click
  Test.log("patient0 has children") if mainPage.patient0.hasChildren?
  mainPage.patient0.printChildren
  
  mainPage.searchBox.enterText("I am searching")
    
    
  #  mainPage.databaseButton.click
  #  mainPage.cdButton.click
  #  mainPage.usbButton.click
  #  mainPage.hardDriveButton.click
  #  mainPage.closeButton.click
end
