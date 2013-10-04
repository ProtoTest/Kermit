##################################################
# Seth Urban - 09/05/13
# This is the template class where child classes will be instantiated from
# containing all the basic API functionality from SQUISH that to be abstracted from the
# test engineer.
##################################################

class BaseScreenObject

  def snagScreenshot(element)
    thing = waitForObject(element.symbolicName)
    image = grabWidget(thing)
    format = "PNG"
    ssName = element.name + "." + format
    ssLoc = @@logFile.testLogLocation
    image.save(ssLoc + ssName, format)
    return ssName
  end

  # Takes a list of elements and verifies the objects are present and visible
  def verifyElementsPresent(elementList, screenName)
    elementList.each do |element|
      begin
        waitForObject(element.symbolicName, 10000)
      rescue Exception => e
        Test.fail("Failed to verify <" + element.name + "> is present in screen #{screenName}")
      end
    end
  end

  def popupOnScreen?
    @popup = WarningDialogPopup.new
    return @popup.onScreen?
    #Test.log("Popup is displayed with title '#{@popup.getTitle}'' and text '#{@popup.getText}' ") if @popup.onScreen?
  end

  def endTest
    @@logFile.CompleteLog()
  end
    
end
