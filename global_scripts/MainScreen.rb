########################################
# Seth Urban
# This is the main screen object child class of the BaseScreenObject
# It will contain all the things displayed on the main entry page.
#########################################
# encoding: UTF-8
require findFile("scripts", "Element.rb")
require findFile("scripts", "ScreenObject.rb")

class MainScreen < BaseScreenObject
  
  
  def initialize
    
    @searchField = Element.new("SearchField", ":Form.search_QLineEdit")
    @firstPatient = Element.new("FirstPatient", ":customTreeWidget.COVIDIEN PHANTOM 2_QModelIndex")
    #@firstPatientOpen = Element.new(":frame.Open Plan_QPushButton")
    @covidienLogo = Element.new("CovidienLogo", ":Form.logo_QLabel")
    @statusBar = Element.new("StatusBar", ":Form.statusBarWidget_QWidget")
   
  end
  
  def searchforRecord(searchText)
    enterText(@searchField, searchText)
    return MainScreen.new
  end
  
  def openRecord
    click(@firstPatient)
    _openPatient = Element.new("FirstPatientOpen", ":frame.Create New Plan_QPushButton")
    click(_openPatient)
    _targetOne = Element.new("FirstPatientTargetONe", ":Form.Add a Target_QPushButton")
    click(_targetOne)
    _ctAxial = Element.new("AxialTarget", ":Form.qvtkWidget_QVTKWidget")
    moveTarget(_ctAxial, "LEFT", 50)
    _editTarget = Element.new("EditTargetOne", ":Form.nameLineEdit_QLineEdit")
    enterText(_editTarget, "Seth Target")
    _targetDetails = Element.new("TargetDetail", ":Form.commentsTextEdit_QPlainTextEdit")
    enterText(_targetDetails, "Here's some stuff to add to the target details thing")
    _saveTargetButton = Element.new("SaveTrgButton", ":Form.Save Target_QPushButton")
    click(_saveTargetButton)
    _saveAblationButton = Element.new("SaveAbButton", ":Form.Save Ablation Zone_QPushButton")
    click(_saveAblationButton)
    _saveEntryPoint = Element.new("SaveEntryPoint", ":Form.Save Entry Point_QPushButton")
    click(_saveEntryPoint)
    _3DThingy = Element.new("3DModel", ":Form.qvtkWidget_QVTKWidget_6")
    dragTarget(_3DThingy, "LEFT", 50)
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