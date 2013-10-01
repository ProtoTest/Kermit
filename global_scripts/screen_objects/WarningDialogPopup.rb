# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "kermit_core\\Element.rb")
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")


class WarningDialogPopup < BaseScreenObject

  def initialize
    @title = Element.new("Popup Title", "{name='titleLabel' type='QLabel' visible='1' window=':WarningDialog_MessageDialog'}")
    @text = Element.new("Popup Text", "{name='warningLabel' type='QLabel' visible='1' window=':WarningDialog_MessageDialog'}")

    # On some popups, the left button may not exist
    @rightBtn = Element.new("Right Button", "{name='rightButton' type='QPushButton' visible='1' window=':WarningDialog_MessageDialog'}")

    # left button on the popup may or may not exist
    if Squish::Object::exists("{name='leftButton' type='QPushButton' visible='1' window=':WarningDialog_MessageDialog'}")
      @leftBtn = Element.new("Left Button", "{name='leftButton' type='QPushButton' visible='1' window=':WarningDialog_MessageDialog'}")
    end

    @closeBtn = Element.new("Close(X) Button", "{name='closeButton' type='QPushButton' visible='1' window=':WarningDialog_MessageDialog'}")
    @captureScreenBtn = Element.new("Capture Screen Button", "{name='captureScreenButton' type='QPushButton' visible='1' window=':WarningDialog_MessageDialog'}")

    @elementList = [@title, @text, @rightBtn, @closeBtn, @captureScreenBtn]

    # add left button if it exists
    (@elementList << @leftBtn) if @leftBtn
  end
  
  def onScreen?
    Squish::Object::exists(":WarningDialog.dialogContainer_QWidget")
  end

  def verifyPopupText(title, text)
    verifyElementsPresent(@elementList, self.class.name)
    verifyPopupText(text)
    verifyPopupTitle(title)

    return self
  end

  def clickBtn(name)
    if (btn = findElementByText(name))
      Test.log("Clicking btn: #{name}")
      click(btn)
    else
      Test.fail("Failed to find #{name} button")
    end

    return self
  end
  
  def getTitle
    return @title.getText
  end

  def getText
    return @text.getText
  end

  # Verifies the popup dialog text matches the parameter text
  def verifyPopupText(text)
    Test.verify(text == @text.getText , "Verify popup text == '#{text}' ")
  end

  def verifyPopupTitle(text)
    Test.verify(text == @title.getText, "Verify popup Title == '#{text}' ")
  end


  private

  def findElementByText(text)
    @elementList.each do |e|
      return e if e.getText == text
    end

    return nil
  end
end