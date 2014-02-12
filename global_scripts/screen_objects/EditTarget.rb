# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "screen_objects\\AddAblationZones.rb")
require findFile("scripts", "screen_objects\\AppHeaderFooter.rb")
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")
require findFile("scripts", "screen_objects\\EditAblation.rb")
require findFile("scripts", "screen_objects\\WarningDialogPopup.rb")

########################################################################################
#
#  EditTarget
#     This screen is presented when users are expecting to edit existing targets already on the selected plan
#
#  @author  Matt Siwiec
#  @notes -10/04/2013 - SU - Changed all BasePageObject clicks and dclicks and enterText to reference Element directly
#
########################################################################################

class EditTarget < BaseScreenObject
  attr_reader :appHeaderFooter

  def initialize
    @appHeaderFooter = AppHeaderFooter.new

    # used to access the individal target tabs
    @targetTabsContainer = Element.new("Target Tabs Bar Container", "{container=':Form_MainForm' type='QTabBar' unnamed='1' visible='1'}")

    # used to access target information child elements
    @targetInfoContainer = Element.new("Target info container", "{container=':stackedWidget.Form_AddTargetsSidePanelForm2' name='widget' type='QWidget' visible='1'}")

    containerChildren = @targetInfoContainer.getChildren

    if containerChildren
      # used squish 'Pick' tool to inspect the container to list the children. Only pulled relevant children to store.
      @targetNameEntry = Element.new("Edit target name text box", ObjectMap.symbolicName(containerChildren[2]))
      @width = Element.new("Width value", ObjectMap.symbolicName(containerChildren[5]))
      @height = Element.new("Height value", ObjectMap.symbolicName(containerChildren[7]))
      @depth = Element.new("Depth value", ObjectMap.symbolicName(containerChildren[9]))
      @volume = Element.new("Volume value", ObjectMap.symbolicName(containerChildren[11]))
      @densityAV = Element.new("Mean - Density", ObjectMap.symbolicName(containerChildren[13]))
      @densityStdDev = Element.new("Standard Deviation - Density", ObjectMap.symbolicName(containerChildren[15]))
      @deleteTargetBtn = Element.new("Delete Target Button", ":Form.Delete Target_QPushButton")
      @addAblationZoneBtn = Element.new("Add an Ablation Zone Button", ":Form.Add an Ablation Zone_QPushButton")

      @elements = [ @targetTabsContainer, @targetInfoContainer, @targetNameEntry, @deleteTargetBtn,
                    @addAblationZoneBtn, @width, @height, @depth, @volume, @densityAV, @densityStdDev ]

      verifyElementsPresent(@elements, self.class.name)
    end
  end

  # Clicks on the Capture Screen button in the application header,sets the filename, and whether
  # to include the patient details in the capture
  # Params: filename - name to give the screenshot
  #         hidePatientDetails - to hide the patient information or not
  def captureScreen(filename, hidePatientDetails=false)
    super(filename, hidePatientDetails)
    return self
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

    raise "#{self.class.name}::#{__method__}(): Failed to find Target tab for '#{name}'"

  end

  def getTargetName
    text = @targetNameEntry.getText
    Log.Trace("#{self.class.name}::#{__method__}(): target note entry text = #{text}")
    return text
  end

  # clicks the delete target button,
  # or optionally selects the target name tab, then clicks delete
  def deleteTarget(name=nil)
    clickTargetTabByName(name) if not name.nil?
    @deleteTargetBtn.click
    snooze 1
    popup =  WarningDialogPopup.new
    popup.verifyPopupTitle("Delete Target")
    popup.verifyPopupText("Are you sure you want to delete the selected target?")

    popup.clickBtn("Delete")

    return AddTargets.new.verifyTargetNotPresent(name)
  end

  def addAblationZone
    @addAblationZoneBtn.click
    return AddAblationZones.new
  end

  # Enter the target name and note into the text field and text area
  def enterTargetInformation(name)
    setTargetName(name) if not name.nil?
    return self
  end

  def verifyTargetInformation(name)
    Log.TestVerify(getTargetName == name, "Verify target name equals: #{name}")
    return self
  end

  ############################# PRIVATE FUNCTIONALITY #############################

  private

  # set the target name with param text
  def setTargetName(text)
    @targetNameEntry.enterText(text) if not text.nil?
    # press TAB on keyboard to set the target name
    type(waitForObject(@targetNameEntry.symbolicName), "<Tab>")
    return self
  end
end