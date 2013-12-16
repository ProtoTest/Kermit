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

    @screenCaptureBtn = Element.new("Capture Screen Button", ":Form.captureScreenButton_QPushButton")

    # The text of these buttons changes depending on what screen you are in, or they may not be visible at all
    @backBtn = Element.new("Back Button", "{name='backButton' type='QPushButton' visible='1' window=':_MainWindow'}")
    @nextBtn = Element.new("Next Button", "{name='nextButton' type='QPushButton' visible='1' window=':_MainWindow'}")

    @elememnts = [@screenCaptureBtn, @backBtn, @nextBtn]

    verifyElementsPresent(@elements, self.class.name)
  end

  def clickBackButton
	  @backBtn.click
  end

  def clickNextButton
	  @nextBtn.click
  end
end