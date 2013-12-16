# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "screen_objects\\AppHeaderFooterEdit.rb")
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")
require findFile("scripts", "screen_objects\\Export.rb")

########################################################################################
#
#  EditAblation
#     Screen Used to Edit the Ablation Zone in a Patient Plan
#
#  @author  Matt Siwiec
#  @notes -10/04/2013 - SU - Changed all BasePageObject clicks and dclicks to reference Element directly
#
########################################################################################

class EditAblation < BaseScreenObject
  def initialize
    @appHeaderFooterEdit = AppHeaderFooterEdit.new

    # use the object real name for elements where the text can change
    @deleteAblationBtn = Element.new("Delete Ablation Zone Button", ":Form.Delete Ablation Zone_QPushButton")
    @doseTable = Element.new("Dose Table dropdown button", "{container=':stackedWidget.Form_AddAblationZonesSidePanelForm2' name='doseTableButton' type='QPushButton' visible='1'}")

    @time = Element.new("Ablation Zone Time", "{container=':stackedWidget.Form_AddAblationZonesSidePanelForm2' name='timeValueLabel' type='QLabel' visible='1'}")
    @diameter = Element.new("Ablation Zone Diameter", "{container=':stackedWidget.Form_AddAblationZonesSidePanelForm2' name='diameterValueLabel' type='QLabel' visible='1'}")
    @minMargin = Element.new("Ablation Zone Min Margin", "{container=':stackedWidget.Form_AddAblationZonesSidePanelForm2' name='minMarginValueLabel' type='QLabel' visible='1'}")
    @maxMargin = Element.new("Ablation Zone Max Margin", "{container=':stackedWidget.Form_AddAblationZonesSidePanelForm2' name='maxMarginValueLabel' type='QLabel' visible='1'}")
    @depth = Element.new("Ablation Needed Depth", "{container=':stackedWidget.Form_AddAblationZonesSidePanelForm2' name='toTargetValueLabel' type='QLabel' visible='1'}")

    @elements = [ @deleteAblationBtn, @doseTable, @time, @diameter, @minMargin, @maxMargin, @depth ]

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

  def clickAddTargets
    @appHeaderFooterEdit.clickBackButton
    return AddTargets.new
  end

  def clickExport
    @appHeaderFooterEdit.clickNextButton
    return Export.new
  end


  def deleteAblation
    @deleteAblationBtn.click
    snooze 1
    popup =  WarningDialogPopup.new
    popup.verifyPopupTitle("Delete Ablation Zone")
    popup.verifyPopupText("Are you sure you want to delete the selected ablation zone?")

    return popup
  end

  # MJS TODO: This isn't working. Latest app changes values to button dropdown
  def enterAblationZoneInfo(doseTableTxt, powerTxt, needText)
    @doseTable.setProperty("text", doseTableTxt)
    snooze 10
  end
end