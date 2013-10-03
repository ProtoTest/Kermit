# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "screen_objects\\AppHeaderFooterEdit.rb")
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")

class EditAblation < BaseScreenObject
  def initialize
    @appHeaderFooterEdit = AppHeaderFooterEdit.new

    # use the object real name for elements where the text can change
    @deleteAblationBtn = Element.new("Delete Ablation Zone Button", ":Form.Delete Ablation Zone_QPushButton")
    @pwr50Btn = Element.new("50W Power Button", ":Form.50 W_QPushButton")
    @pwr75Btn = Element.new("75W Power Button", ":Form.75 W_QPushButton")
    @pwr100Btn = Element.new("100W Power Button", ":Form.100 W_QPushButton")
    @time = Element.new("Ablation Zone Time", "{container=':stackedWidget.Form_AddAblationZonesSidePanelForm2' name='timeValueLabel' type='QLabel' visible='1'}")
    @diameter = Element.new("Ablation Zone Diameter", "{container=':stackedWidget.Form_AddAblationZonesSidePanelForm2' name='diameterValueLabel' type='QLabel' visible='1'}")
    @minMargin = Element.new("Ablation Zone Min Margin", "{container=':stackedWidget.Form_AddAblationZonesSidePanelForm2' name='minMarginValueLabel' type='QLabel' visible='1'}")
    @maxMargin = Element.new("Ablation Zone Max Margin", "{container=':stackedWidget.Form_AddAblationZonesSidePanelForm2' name='maxMarginValueLabel' type='QLabel' visible='1'}")
    #@needleCA20L1Btn = Element.new("Ablation Needle Button", ":Form.CA20L1_QPushButton") #this may have been removed
    @depth = Element.new("Ablation Needed Depth", "{container=':stackedWidget.Form_AddAblationZonesSidePanelForm2' name='toTargetValueLabel' type='QLabel' visible='1'}")
    
    @elements = [@deleteAblationBtn, @pwr50Btn, @pwr75Btn, @pwr100Btn, @time, @diameter]
    @elements << [@minMargin, @maxMargin, @depth] #removed @needleCA20L1Btn
    # one dimensional flattening of elements array
    @elements.flatten!

    verifyElementsPresent(@elements, self.class.name)
  end
  
  def clickAddTargets
    @appHeaderFooterEdit.clickBackButton
    return AddTargets.new
  end
  
  def clickExport
    @appHeaderFooterEdit.clickNextButton
    # return Export.new
  end

  def clickDeleteAblation
    click(@deleteAblationBtn)
    snooze 1
    popup =  WarningDialogPopup.new
    popup.verifyPopupTitle("Delete Ablation Zone")
    popup.verifyPopupText("Are you sure you want to delete the selected ablation zone?")

    return popup
  end
end