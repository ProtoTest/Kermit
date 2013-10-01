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
    # check for the out of memory popup
    if popupOnScreen?
      @popup.clickBtn("OK")
    end

    @searchField = Element.new("SearchField", ":Form.search_QLineEdit")
    @patientTable = PatientTable.new
    @appHeaderFooter = AppHeaderFooter.new

    @elements = [@searchField]
    verifyElementsPresent(@elements, self.class.name)
   
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
    @appHeaderFooter.clickRadio(RadioButtons::LOAD_IMAGES)
    return MainScreen.new
  end

  def clickAddTargetsRadio
    @appHeaderFooter.clickRadio(RadioButtons::ADD_TARGETS)
  end

  def clickAddAblationZonesRadio
    @appHeaderFooter.clickRadio(RadioButtons::ADD_ABLATION)
  end

  def clickExportRadio
    @appHeaderFooter.clickRadio(RadioButtons::EXPORT)
  end

  def getPatientList
    return @patientTable.patientList
  end

  def scrollToPatientIndex(index)
    @patientTable.scrollToRowByIndex(index)
    return MainScreen.new
  end

  def openPatientDetails(patient)
    return patient.openPatientDetails
  end
end