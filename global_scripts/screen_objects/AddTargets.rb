# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "screen_objects\\AppHeaderFooterEdit.rb")
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")
require findFile("scripts", "screen_objects\\EditTarget.rb")

########################################################################################
#
#  Add Targets
#     This screen is presented when users are expecting to add a new target to the plan
#
#  @author  Matt Siwiec
#  @notes -10/04/2013 - SU - Changed all BasePageObject clicks and dclicks and enterText to reference Element directly 
#
########################################################################################


class AddTargets < BaseScreenObject
  def initialize
    @addTargetBtn = Element.new("Add a Target Button", ":Form.Add a Target_QPushButton")
    
    @appHeaderFooterEdit = AppHeaderFooterEdit.new

    @elements = [@addTargetBtn]
    verifyElementsPresent(@elements, self.class.name)
  end
  
  def clickLoadImages
    @appHeaderFooterEdit.clickBackButton
    return MainScreen.new
  end

  def clickAddAblationZones
    @appHeaderFooterEdit.clickNextButton
    return AddAblationZones.new
  end

  def clickAddTarget
    @addTargetBtn.click
    return EditTarget.new
  end
end