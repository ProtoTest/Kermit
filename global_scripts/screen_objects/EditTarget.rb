# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "screen_objects\\AddAblationZones.rb")
require findFile("scripts", "screen_objects\\AppHeaderFooterEdit.rb")
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")
require findFile("scripts", "screen_objects\\EditAblation.rb")
require findFile("scripts", "screen_objects\\WarningDialogPopup.rb")

class EditTarget < BaseScreenObject
  def initialize
    @targetNameEntry = Element.new("Edit target name text box", ":Form.nameLineEdit_QLineEdit")
    @targetNotesEntry = Element.new("Edit target notes text area", ":Form.notesTextEdit_QPlainTextEdit")
    @width = Element.new("Width value", "{container=':stackedWidget.Form_AddTargetsSidePanelForm2' name='widthValueLabel' type='QLabel' visible='1'}")
    @height = Element.new("Height value", "{container=':stackedWidget.Form_AddTargetsSidePanelForm2' name='heightValueLabel' type='QLabel' visible='1'}")
    @depth = Element.new("Depth value", "{container=':stackedWidget.Form_AddTargetsSidePanelForm2' name='depthValueLabel' type='QLabel' visible='1'}")
    @volume = Element.new("Volume value", "{container=':stackedWidget.Form_AddTargetsSidePanelForm2' name='targetVolumeValueLabel' type='QLabel' visible='1'}")
    @deleteTargetBtn = Element.new("Delete Target Button", ":Form.Delete Target_QPushButton")

    @appHeaderFooterEdit = AppHeaderFooterEdit.new

    @elements = [@targetNameEntry, @targetNotesEntry, @deleteTargetBtn]
    @elements << [@width, @height, @depth, @volume]
    # one dimensional flattening of elements array
    @elements.flatten!

    verifyElementsPresent(@elements, self.class.name)
  end
  
  def setTargetName(text)
    enterText(@targetNameEntry, text) if not text.nil?
    return self
  end

  def setNote(text)
    enterText(@targetNotesEntry, text) if not text.nil?
    return self
  end

  def clickAddAblationZone
    @appHeaderFooterEdit.clickNextButton
    snooze 1
    return AddAblationZones.new
  end
  
  def clickDeleteTarget
    click(@deleteTargetBtn)
    snooze 1
    popup =  WarningDialogPopup.new
    popup.verifyPopupTitle("Delete Target")
    popup.verifyPopupText("Are you sure you want to delete the selected target?")

    return popup
  end
end