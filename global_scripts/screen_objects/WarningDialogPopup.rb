# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "kermit_core\\Element.rb")
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")

########################################################################################
#
#  Warning Dialog Popup
#     Contains all the elements for any Warning message Popup presented when deleteing patient data or on start up
#
#  @author  Matt Siwiec
#  @notes - 10/03/2013 - SU - Updated elements RealID changed from {name='titleLabel' type='QLabel' visible='1' window=':WarningDialog_MessageDialog'} to {name='titleLabel' type='QLabel' visible='1' window=':MessageDialog_MessageDialog'}
#  	10/04/2013 - SU - Added standard comment block, changed references to clicks and dclicks from BaseScreenObject to Element Class
#
########################################################################################

class WarningDialogPopup < BaseScreenObject

  def initialize
    @title = Element.new("Popup Title", "{name='titleLabel' type='QLabel' visible='1' window=':MessageDialog_MessageDialog'}")

    @text = Element.new("Popup Text", "{name='warningLabel' type='QLabel' visible='1' window=':MessageDialog_MessageDialog'}")

    # On some popups, the left button may not exist
    @rightBtn = Element.new("Right Button", "{name='rightButton' type='QPushButton' visible='1' window=':MessageDialog_MessageDialog'}")

    # left button on the popup may or may not exist
    if Squish::Object::exists("{name='leftButton' type='QPushButton' visible='1' window=':MessageDialog_MessageDialog'}")
      @leftBtn = Element.new("Left Button", "{name='leftButton' type='QPushButton' visible='1' window=':MessageDialog_MessageDialog'}")
    end

    @closeBtn = Element.new("Close(X) Button", "{name='closeButton' type='QPushButton' visible='1' window=':MessageDialog_MessageDialog'}")
    @captureScreenBtn = Element.new("Capture Screen Button", "{name='captureScreenButton' type='QPushButton' visible='1' window=':MessageDialog_MessageDialog'}")

    @elementList = [@title, @text, @rightBtn, @closeBtn, @captureScreenBtn]

    # add left button if it exists
    (@elementList << @leftBtn) if @leftBtn

    verifyElementsPresent(@elementList, self.class.name)
  end

  # Class method: Returns true if the warning dialog popup is on screen, false otherwise
  def self.onScreen?
    return Squish::Object::exists(":MessageDialog.dialogContainer_QWidget")
  end

  # Peforms a squish Test validation on the popup title and text
  def verifyPopupInformation(title, text)
    verifyElementsPresent(@elementList, self.class.name)
    verifyPopupText(text)
    verifyPopupTitle(title)

    return self
  end

  # Clicks the button on the popup by name
  # Param: name - the popup button name to click
  def clickBtn(name)
    if (btn = findElementByText(name))
      Log.TestLog("#{self.class.name}::#{__method__}(): Clicking button: '#{name}' ")
      btn.click
    else
      Log.TestFail("#{self.class.name}::#{__method__}(): Failed to find #{name} button")
    end

    return self
  end

  # Returns the popup title text
  def getTitle
    return @title.getText.to_s.strip
  end

  # Returns the popup description text
  def getText
    return @text.getText.to_s.strip
  end

  # Verifies the popup dialog description matches the parameter 'text'
  def verifyPopupText(text)
    Log.TestVerify(text == @text.getText , "Verify popup text == '#{text}' ")
  end

  # Verifies the popup dialog title matches the parameter 'text'
  def verifyPopupTitle(text)
    Log.TestVerify(text == @title.getText, "Verify popup Title == '#{text}' ")
  end


############################### PRIVATE FUNCTIONALITY ####################################

  private

  # Returns the element in the popup with text 'text'
  def findElementByText(text)
    @elementList.each do |e|
      return e if e.getText == text
    end

    return nil
  end

end
