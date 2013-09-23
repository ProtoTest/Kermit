# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "kermit_core\\Element.rb")
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")
require findFile("scripts", "screen_objects\\EditTargetScreen.rb")

class WarningDialogPopup < BaseScreenObject

  def initialize
    @cancelBtn = Element.new("Warning Diaglog Cancel Button", ":WarningDialog.Cancel_QPushButton")
    @deleteBtn = Element.new("Warning Diaglog Delete Button", ":WarningDialog.Delete_QPushButton")
    @dialogTextLabel = Element.new("Warning Diaglog Text Label", "{name='warningLabel1' type='QLabel' visible='1' window=':WarningDialog_WarningDialog'}")

    @elementList = Array.new
    @elementList << @cancelBtn
    @elementList << @deleteBtn
    @elementList << @dialogTextLabel

    verifyElementsPresent(@elementList)
    Test.log("Initialized Warning Dialog Popup")
  end
  
  def clickCancel
    click(@cancelBtn)
    Test.log("Clicking cancel button on WarningDialogPopup")
  end
  
  def clickDelete
    click(@deleteBtn)
    Test.log("Clicking delete button on WarningDialogPopup")
  end

  # Verifies the popup dialog text matches the parameter text
  def verifyPopupText(text)
    Test.verify(text == @dialogTextLabel.getProperty['text'])
  end
end