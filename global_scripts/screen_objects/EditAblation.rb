# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "screen_objects\\AppHeaderFooterEdit.rb")
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")
require findFile("scripts", "screen_objects\\Export.rb")

# Constants to use to select dropdown button values in this screen.
# Make sure they match the order in the application.
# Each of these module constants MUST start at 1 to allow enterAblationZoneInfo()
# to click on each button and press the arrow key down to select the requested option.
module DoseTableOptions
  LIVER = 1
  LUNG = 2
end

module PowerOptions
  WATTS_45 = 1
  WATTS_75 = 2
  WATTS_100 = 3
end

module NeedleOptions
  EMPRINT_15_CM = 1
  EMPRINT_20_CM = 2
  EMPRINT_30_CM = 3
end

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
  attr_reader :appHeaderFooter

  def initialize
    # application header and footer for specifically edit screens
    @appHeaderFooter = AppHeaderFooterEdit.new

    # use the object real name for elements where the text can change
    @deleteAblationBtn = Element.new("Delete Ablation Zone Button", ":Form.Delete Ablation Zone_QPushButton")
    @doseTable = Element.new("Dose Table dropdown button", "{container=':stackedWidget.Form_AddAblationZonesSidePanelForm2' name='doseTableButton' type='QPushButton' visible='1'}")
    @power = Element.new("Power dropdown button", "{container=':stackedWidget.Form_AddAblationZonesSidePanelForm2' name='powerButton' type='QPushButton' visible='1'}")
    @time = Element.new("Ablation Zone Time", "{container=':stackedWidget.Form_AddAblationZonesSidePanelForm2' name='timeValueLabel' type='QLabel' visible='1'}")
    @diameter = Element.new("Ablation Zone Diameter", "{container=':stackedWidget.Form_AddAblationZonesSidePanelForm2' name='diameterValueLabel' type='QLabel' visible='1'}")
    @minMargin = Element.new("Ablation Zone Min Margin", "{container=':stackedWidget.Form_AddAblationZonesSidePanelForm2' name='minMarginValueLabel' type='QLabel' visible='1'}")
    @maxMargin = Element.new("Ablation Zone Max Margin", "{container=':stackedWidget.Form_AddAblationZonesSidePanelForm2' name='maxMarginValueLabel' type='QLabel' visible='1'}")
    @needle = Element.new("Needle dropdown button", "{container=':stackedWidget.Form_AddAblationZonesSidePanelForm2' name='needleButton' type='QPushButton' visible='1'}")
    @depth = Element.new("Ablation Needed Depth", "{container=':stackedWidget.Form_AddAblationZonesSidePanelForm2' name='toTargetValueLabel' type='QLabel' visible='1'}")

    @elements = [ @deleteAblationBtn, @doseTable, @power, @time, @diameter, @minMargin, @maxMargin, @needle, @depth ]

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
    @appHeaderFooter.clickBackButton
    return AddTargets.new
  end

  def clickExport
    @appHeaderFooter.clickNextButton
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

  # Sets the Dose, Power, and Needle options for the Edit Ablation Zone form
  #
  # Params:
  #         doseTableOption - Option from module DoseTableOptions
  #         powerOption - Option from module PowerOptions
  #         needleOption - Option from module NeedleOptions
  def enterAblationZoneInfo(doseTableOption, powerOption, needleOption)
    case doseTableOption
      when DoseTableOptions::LUNG, DoseTableOptions::LIVER
        @doseTable.click
        snooze 1
        doseTableOption.times { nativeType("<Down>"); snooze 1 }
        nativeType("<Return>")
        snooze 1
      else
        @@logFile.TestFail("#{self.class.name}::#{__method__}(): Invalid doseTableOption ID (#{doseTableOption})")
    end

    case powerOption
      when PowerOptions::WATTS_45, PowerOptions::WATTS_75, PowerOptions::WATTS_100
        @power.click
        snooze 1
        powerOption.times { nativeType("<Down>"); snooze 1 }
        nativeType("<Return>")
        snooze 1
      else
        @@logFile.TestFail("#{self.class.name}::#{__method__}(): Invalid powerOption ID (#{powerOption})")
    end

    case needleOption
      when NeedleOptions::EMPRINT_15_CM, NeedleOptions::EMPRINT_20_CM, NeedleOptions::EMPRINT_30_CM
        @needle.click
        snooze 1
        needleOption.times { nativeType("<Down>"); snooze 1 }
        nativeType("<Return>")
        snooze 1
      else
        @@logFile.TestFail("#{self.class.name}::#{__method__}(): Invalid needleOption ID (#{needleOption})")
    end

    return self
  end

  ############################### PRIVATE FUNCTIONALITY ####################################
  private

end