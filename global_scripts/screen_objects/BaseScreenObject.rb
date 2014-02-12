
##################################################
# Seth Urban - 09/05/13
# This is the template class where child classes will be instantiated from
# containing all the basic API functionality from SQUISH that to be abstracted from the
# test engineer.
##################################################

class BaseScreenObject

  # Clicks on the Capture Screen button in the application header,sets the filename, and whether
  # to include the patient details in the capture
  # Params: filename - name to give the screenshot
  #         hidePatientDetails - to hide the patient information or not
  def captureScreen(filename, hidePatientDetails=false)
    screenCaptureBtn = Element.new("Capture Screen Button", ":Form.captureScreenButton_QPushButton")
    screenCaptureBtn.click
    ScreenCapturePopup.new.saveScreenshot(filename, hidePatientDetails)
  end

  # Takes a list of elements and verifies the objects are present and visible.
  # This will fail on an element if the object in question is not 'enabled'
  def verifyElementsPresent(elementList, screenName, timeout = OBJECT_WAIT_TIMEOUT)
    elementList.each do |element|
      begin
        waitForObject(element.symbolicName, timeout)
      rescue Exception => e
        Log.TestFail("#{self.class.name}::#{__method__}(): Failed to verify '#{element.name}' is present and enabled in screen #{screenName}")
      end
    end
  end

  # Checks to see if any popups are displayed on the screen
  def popupOnScreen?
    @popup = WarningDialogPopup.new
    Log.TestLog("#{self.class.name}::#{__method__}(): Popup is displayed with title '#{@popup.getTitle}' and text '#{@popup.getText}' ") if @popup.onScreen?
    return @popup.onScreen?
  end

end
