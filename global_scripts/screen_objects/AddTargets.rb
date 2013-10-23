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

    # used to access the individal target tabs
    @targetTabsContainer = Element.new("Target Tabs Bar Container", "{container=':Form_MainForm' type='QTabBar' unnamed='1' visible='1'}")
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

  def clickTargetTabByName(name)
    children = @targetTabsContainer.getChildren
    children.each do |child|
      if child.respond_to?(:text) and (child.text == name)
        ObjectMap.add(child)
        Element.new("Target Tab", ObjectMap.symbolicName(child)).click
        return EditTarget.new
      end
    end

    @@logFile.Fail("Failed to find Target tab for '#{name}'")
    return nil
  end

end