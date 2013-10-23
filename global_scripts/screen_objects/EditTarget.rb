# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "screen_objects\\AddAblationZones.rb")
require findFile("scripts", "screen_objects\\AppHeaderFooterEdit.rb")
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
  attr_reader :appHeaderFooterEdit

  def initialize
    @targetNameEntry = Element.new("Edit target name text box", ":Form.nameLineEdit_QLineEdit")
    @targetNotesEntry = Element.new("Edit target notes text area", ":Form.notesTextEdit_QPlainTextEdit")
    @width = Element.new("Width value", "{container=':stackedWidget.Form_AddTargetsSidePanelForm2' name='widthValueLabel' type='QLabel' visible='1'}")
    @height = Element.new("Height value", "{container=':stackedWidget.Form_AddTargetsSidePanelForm2' name='heightValueLabel' type='QLabel' visible='1'}")
    @depth = Element.new("Depth value", "{container=':stackedWidget.Form_AddTargetsSidePanelForm2' name='depthValueLabel' type='QLabel' visible='1'}")
    @volume = Element.new("Volume value", "{container=':stackedWidget.Form_AddTargetsSidePanelForm2' name='targetVolumeValueLabel' type='QLabel' visible='1'}")
    @deleteTargetBtn = Element.new("Delete Target Button", ":Form.Delete Target_QPushButton")

    @appHeaderFooterEdit = AppHeaderFooterEdit.new

    # used to access the individal target tabs
    @targetTabsContainer = Element.new("Target Tabs Bar Container", "{container=':Form_MainForm' type='QTabBar' unnamed='1' visible='1'}")

    @elements = [@targetNameEntry, @targetNotesEntry, @deleteTargetBtn, @targetTabsContainer]
    @elements << [@width, @height, @depth, @volume]
    # one dimensional flattening of elements array
    @elements.flatten!

    verifyElementsPresent(@elements, self.class.name)

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

    @@logFile.Fail("#{self.class.name}::#{__method__}(): Failed to find Target tab for '#{name}'")
    return nil
  end

  def getTargetName
    text = @targetNameEntry.getText
    @@logFile.Trace("#{self.class.name}::#{__method__}(): target note entry text = #{text}")
    return text
  end

  def getTargetNote
    text = @targetNotesEntry.getTextArea
    @@logFile.Trace("#{self.class.name}::#{__method__}(): target note entry text = #{text}")
    return text
  end

  def setTargetName(text)
    @targetNameEntry.enterText(text) if not text.nil?
    return self
  end

  def setTargetNote(text)
    @targetNotesEntry.enterText(text) if not text.nil?
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

  def clickDeleteTarget
    click(@deleteTargetBtn)
    snooze 1
    popup =  WarningDialogPopup.new
    popup.verifyPopupTitle("Delete Target")
    popup.verifyPopupText("Are you sure you want to delete the selected target?")

    return popup
  end

  def enterTargetInformation(name, note)
    setTargetName(name)
    setTargetNote(note)
    return self
  end

  def verifyTargetInformation(name, note)
    @@logFile.TestVerify(getTargetName == name, "Verify target name equals: #{name}")
    @@logFile.TestVerify(getTargetNote == note, "Verify target note equals: #{note}")
    return self
  end

end