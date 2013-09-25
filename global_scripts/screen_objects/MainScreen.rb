# encoding: UTF-8
require 'squish'
include Squish

########################################
# Seth Urban
# This is the main screen object child class of the BaseScreenObject
# It will contain all the things displayed on the main entry page.
#########################################
# encoding: UTF-8
require findFile("scripts", "kermit_core\\Element.rb")
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")
require findFile("scripts", "screen_objects\\AppHeaderFooter.rb")
require findFile("scripts", "screen_objects\\PatientTable.rb")

class MainScreen < BaseScreenObject
  attr_reader :patientTable
  
  def initialize
    
    @searchField = Element.new("SearchField", ":Form.search_QLineEdit")
    @covidienLogo = Element.new("CovidienLogo", ":Form.logo_QLabel")
    @statusBar = Element.new("StatusBar", ":Form.statusBarWidget_QWidget")
    @patientTable = PatientTable.new
    @appHeaderFooter = AppHeaderFooter.new

    @elements = [@searchField, @covidienLogo, @statusBar]
    verifyElementsPresent(@elements)
   
  end
  
  def searchforRecord(searchText)
    enterText(@searchField, searchText)
    return MainScreen.new
  end  
   
   
  def clickPatient(patientName)
    patient = nil
   @patientTable.patientList.each do |x|
     if x.name == patientName
       patient = x
       break
     end
   end
   
   if patient.nil?
     Test.fail("Failed to find patient " + patientName)
     return nil
   else
     return patient.openPatientDetails
   end
  end

  def clickLoadImagesRadio
    click(@appHeaderFooter.loadImagesRadio)
    return MainScreen.new
  end

  def getPatientList
    @patientTable.patientList
  end

  def scrollToPatientIndex(index)
    @patientTable.scrollToRowByIndex(index)
    return MainScreen.new
  end
end