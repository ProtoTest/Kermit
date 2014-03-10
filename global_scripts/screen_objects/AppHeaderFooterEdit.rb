# this is an extension of the AppHeaderFooter screen within the Edit screens

require findFile("scripts", "screen_objects\\AppHeaderFooter.rb")

########################################################################################
#
#  AppHeaderFooter Edit
#     This is an addition to the Standard AppHeaderFooter presented when users are able to edit targets and ablations
#
#  @author  Matt Siwiec
#  @notes -10/04/2013 - SU - Changed all BasePageObject clicks and dclicks to reference Element directly
#
########################################################################################

class AppHeaderFooterEdit < AppHeaderFooter
  def initialize
  	# intialize parent class
    super

    # The text of these buttons changes depending on what screen you are in, or they may not be visible at all
    @backBtn = Element.new("Back Button", "{name='backButton' type='QPushButton' visible='1' window=':_MainWindow'}")
    @nextBtn = Element.new("Next Button", "{name='nextButton' type='QPushButton' visible='1' window=':_MainWindow'}")

    @elememnts = [@backBtn, @nextBtn]

    verifyElementsPresent(@elements, self.class.name)
  end

  def clickBackButton
	  @backBtn.click
  end

  def clickNextButton
	  @nextBtn.click
  end

    # Clicks on the Capture Screen button in the application header,sets the filename, and whether
  # to include the patient details in the capture.
  # Note: This button may not be available in all screens
  # Params: filename - optional file name to give the screenshot. Defaults to filename pre-populated by AUT
  #         hidePatientDetails - to hide the patient information or not
  def captureScreen(filename=nil, hidePatientDetails=false)
    screenCaptureBtn = Element.new("Capture Screen Button", ":Form.captureScreenButton_QPushButton")
    screenCaptureBtn.click
    snooze 1
    ScreenCapturePopup.new.saveScreenshot(filename, hidePatientDetails)
  end
end