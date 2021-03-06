# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "screen_objects\\AppHeaderFooter.rb")
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
  attr_reader :imageArea, :appHeaderFooter

  def initialize
    @appHeaderFooter = AppHeaderFooter.new

    # used to access the individal target tabs
    @targetTabsContainer = Element.new("Target Tabs Bar Container", "{container=':Form_MainForm' type='QTabBar' unnamed='1' visible='1'}")
    @visualizeBtn = Element.new("Visualize Tab Button", ":Visualize_TabItem")
    @addTargetBtn = Element.new("Add a Target Button", ":Form.Add a Target_QPushButton")
    @singleSliceBtn = Element.new("Single Slice Button", ":Form.Single Slice_QPushButton")
    @imageArea = Element.new("CT Image Area", ":LocalizerForm.verticalSlider_QSlider")
    verifyElementsPresent([@singleSliceBtn], self.class.name)
    @singleSliceBtn.click
    @elements = [@addTargetBtn, @visualizeBtn, @targetTabsContainer, @imageArea]
    waitForObject(@targetTabsContainer.symbolicName, 90000)
    verifyElementsPresent(@elements, self.class.name)
  end

  # Clicks on the Capture Screen button in the application header,sets the filename, and whether
  # to include the patient details in the capture
  # Params: filename - optional filename to give the screenshot
  #         hidePatientDetails - to hide the patient information or not
  def captureScreen(filename=nil, hidePatientDetails=false)
    @appHeaderFooterEdit.captureScreen(filename, hidePatientDetails)
    return self
  end

  def clickLoadImages
    @appHeaderFooter.clickLoadImagesRadio
    return MainScreen.new
  end

  def clickAddAblationZones
    @appHeaderFooterEdit.clickNextButton
    return AddAblationZones.new
  end

  def clickVisualize
    @visualizeBtn.click
    return AddTargets.new
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

    raise "#{self.class.name}::#{__method__}(): Failed to find Target tab for '#{name}'"

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

      Log.TestVerify(targetFound==false, "Verify Target '#{name}' not present")
    else
      Log.TestFail("#{self.class.name}::#{__method__}(): Invalid parameter: name is nil")
    end

    return self
  end
end