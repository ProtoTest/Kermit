# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "screen_objects\\AppHeaderFooterEdit.rb")
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")
require findFile("scripts", "screen_objects\\EditAblation.rb")

########################################################################################
#
#  AddAblationZones
#     This is the screen presented when Ablation Zones are added.  It will consist of more than one button at some point
#
#  @author  Matt Siwiec
#  @notes -10/04/2013 - SU - Changed all BasePageObject clicks and dclicks to reference Element directly 
#
########################################################################################

class AddAblationZones < BaseScreenObject
  def initialize
  	@addAblationBtn = Element.new("Add Ablation Zone button", ":Form.Add Ablation Zone_QPushButton")
  	@appHeaderFooterEdit = AppHeaderFooterEdit.new

    @elements = [@addAblationBtn]
    verifyElementsPresent(@elements, self.class.name)
  end

  def clickAddTargets
    @appHeaderFooterEdit.clickBackButton
    return MainScreen.new
  end

  def clickExport
    @appHeaderFooterEdit.clickNextButton
    return Export.new
  end

  def clickAddAblation
    @addAblationBtn.click
  	return EditAblation.new
  end
end