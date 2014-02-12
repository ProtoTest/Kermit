# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "screen_objects\\AppHeaderFooter.rb")
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")
require findFile("scripts", "screen_objects\\WarningDialogPopup.rb")
require findFile("scripts", "screen_objects\\Export.rb")

########################################################################################
#
#  AddAblationZones
#     This is the screen presented when Ablation Zones are added.  It will consist of
#     more than one button at some point
#
#  @author  Matt Siwiec
#  @notes -10/04/2013 - SU - Changed all BasePageObject clicks and dclicks to reference Element directly
#
########################################################################################

class AddAblationZones < BaseScreenObject
  def initialize
  	@deleteAblationZoneBtn = Element.new("Delete Ablation Zone button", ":Form.Delete Ablation Zone_QPushButton")
  	@appHeaderFooter = AppHeaderFooter.new

    @elements = [@deleteAblationZoneBtn]
    verifyElementsPresent(@elements, self.class.name)
  end

  # Clicks on the Capture Screen button in the application header,sets the filename, and whether
  # to include the patient details in the capture
  # Params: filename - name to give the screenshot
  #         hidePatientDetails - to hide the patient information or not
  def captureScreen(filename, hidePatientDetails=false)
    super(filename, hidePatientDetails)
    return self
  end

  def deleteAblation
    popupText = "Are you sure you want to delete the selected ablation zone?"
    @deleteAblationZoneBtn.click
  	return WarningDialogPopup.new.verifyPopupInformation(popupText)
  end
end