# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "kermit_core\\Element.rb")
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")

########################################################################################
#
#  Screen Capture Popup
#     Contains all the elements for the Screen Capture Dialog Popup presented when taking a screen capture
#
#  @author  Matt Siwiec
#
#
########################################################################################
class ScreenCapturePopup < BaseScreenObject
  TAG = "Screen Capture Popup"

  def initialize
  	@closeBtn = Element.new("#{TAG}: Close Button", "{name='closeButton' type='QPushButton' visible='1' window=':ScreenCaptureDialog_ScreenCaptureDialog'}")
  	@fileNameTextField = Element.new("#{TAG}: File name text entry", "{name='fileNameEdit' type='QLineEdit' visible='1' window=':ScreenCaptureDialog_ScreenCaptureDialog'}")
  	@hideDetailsCheckBox = Element.new("#{TAG}: Hide patient details checkbox", "{name='patientDetailsCheckBox' text='Hide patient details in the screen capture' type='QCheckBox' visible='1' window=':ScreenCaptureDialog_ScreenCaptureDialog'}")
  	@cancelBtn = Element.new("#{TAG}: cancel button", "{name='cancelButton' text='Cancel' type='QPushButton' visible='1' window=':ScreenCaptureDialog_ScreenCaptureDialog'}")
  	@saveBtn = Element.new("#{TAG}: save button", "{name='saveButton' text='Save' type='QPushButton' visible='1' window=':ScreenCaptureDialog_ScreenCaptureDialog'}")

  	@elements = [@closeBtn, @fileNameTextField, @hideDetailsCheckBox, @cancelBtn, @saveBtn]

  	verifyElementsPresent(@elements, self.class.name)
  end

  # Saves a screenshot
  # Param: filename - The name to give to screen shot
  #        hidePatientDetails - optional boolean to check patient details or not
  def saveScreenshot(filename, hidePatientDetails=false)
  	@@logFile.TestLog("Saving screenshot to '#{filename}.png'")
  	@fileNameTextField.enterText(filename)
  	checkHideDetails if hidePatientDetails
  	clickSave
  end

  def clickSave
  	@saveBtn.click
  end

  def clickCancel
  	@cancelBtn.click
  end

  def checkHideDetails
  	@hideDetailsCheckBox.click
  end
end
