# encoding: UTF-8
require findFile("scripts", "Element.rb")
require findFile("scripts", "ScreenObject.rb")

class MainScreen < BaseScreenObject
  
  
  def initialize
    
    @searchField = Element.new(":Form.search_QLineEdit")
    @firstPatient = Element.new(":customTreeWidget.COVIDIEN PHANTOM 2_QModelIndex")
    #@firstPatientOpen = Element.new(":frame.Open Plan_QPushButton")
    @covidienLogo = Element.new(":Form.logo_QLabel")
    @statusBar = Element.new(":Form.statusBarWidget_QWidget")
   
  end
  
  def searchforRecord(searchText)
    enterText(@searchField, searchText)
    return MainScreen.new
  end
  
  def openRecord
    clickButton(@firstPatient)
    _openPatient = Element.new(":frame.Open Plan_QPushButton")
    clickButton(_openPatient)
    _targetOne = Element.new(":Target_1_TabItem")
    clickButton(_targetOne)
    _editTarget = Element.new(":Form.Edit Target Details_QPushButton")
    return MainScreen.new
  end
  
  def testMousy
    moveTarget(@covidienLogo)
    snooze(1)
    moveTarget(@statusBar)
    snooze(1)
    moveTarget(@covidienLogo)
    snooze(1)
    moveTarget(@statusBar)
    snooze(1)
    moveTarget(@covidienLogo)
    snooze(1)
    moveTarget(@statusBar)
    return MainScreen.new
  end
end