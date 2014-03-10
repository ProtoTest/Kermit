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
    @closeBtn = Element.new("#{TAG}: Close Button", ":ScreenCaptureDialog.closeButton_QPushButton")
    @fileNameTextField = Element.new("#{TAG}: File name text entry", ":ScreenCaptureDialog.fileNameEdit_QLineEdit")
    @hideDetailsCheckBox = Element.new("#{TAG}: Hide patient details checkbox", ":ScreenCaptureDialog.Hide patient details in the snapshot_QCheckBox")
    @cancelBtn = Element.new("#{TAG}: cancel button", ":ScreenCaptureDialog.Cancel_QPushButton")
    @saveBtn = Element.new("#{TAG}: save button", ":ScreenCaptureDialog.Save_QPushButton")

  	@elements = [@closeBtn, @fileNameTextField, @hideDetailsCheckBox, @cancelBtn, @saveBtn]

  	verifyElementsPresent(@elements, self.class.name)
  end

  # Saves a screenshot
  # Param: filename - The optional filename to give to screen shot
  #        hidePatientDetails - optional boolean to check patient details or not
  def saveScreenshot(filename=nil, hidePatientDetails=false)
    if filename.nil?
      filename = @fileNameTextField.getText
    else
      # Enter the filename in the text field
      @fileNameTextField.enterText(filename)
    end

  	Log.TestLog("Saving screenshot to '#{filename}.png'")
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
