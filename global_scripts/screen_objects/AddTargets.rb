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
    @appHeaderFooterEdit = AppHeaderFooterEdit.new

    # used to access the individal target tabs
    @targetTabsContainer = Element.new("Target Tabs Bar Container", "{container=':Form_MainForm' type='QTabBar' unnamed='1' visible='1'}")
    @addTargetBtn = Element.new("Add a Target Button", ":Form.Add a Target_QPushButton")

    @elements = [@addTargetBtn, @targetTabsContainer]
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

  def clickLoadImages
    @appHeaderFooterEdit.clickBackButton
    return MainScreen.new
  end

  def clickAddAblationZones
    @appHeaderFooterEdit.clickNextButton
    return AddAblationZones.new
  end

  # clicks on the add target button and optionally enters the target name (if defined)
  def addTarget(name=nil, note=nil)
    @addTargetBtn.click
    return EditTarget.new.enterTargetInformation(name)
  end

  def clickTargetTabByName(name)
    children = @targetTabsContainer.getChildren
    Test.log("Found #{children.size} children")

    children.each do |child|
      if child.respond_to?(:text) and (child.text == name)
        ObjectMap.add(child)
        Element.new("Target Tab", ObjectMap.symbolicName(child)).click
        return EditTarget.new
      end
    end

    @@logFile.TestFail("#{self.class.name}::#{__method__}(): Failed to find Target tab for '#{name}'")
    return nil
  end

  def verifyTargetNotPresent(name)
    if not name.nil?
      children = @targetTabsContainer.getChildren

      targetFound = false

      children.each do |child|
        if child.respond_to?(:text) and (child.text == name)
          targetFound = true
        end
      end

      @@logFile.TestVerify(targetFound==false, "Verify Target '#{name}' not present")
    else
      @@logFile.TestFail("#{self.class.name}::#{__method__}(): Invalid parameter: name is nil")
    end

    return self
  end
end