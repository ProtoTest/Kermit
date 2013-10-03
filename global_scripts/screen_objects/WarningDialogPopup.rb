# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "kermit_core\\Element.rb")
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")


class WarningDialogPopup < BaseScreenObject
##Updated Elements here realID changed from :{name='titleLabel' type='QLabel' visible='1' window=':WarningDialog_MessageDialog'} to {name='titleLabel' type='QLabel' visible='1' window=':MessageDialog_MessageDialog'}
##Had to do a few updates to this screen to get it to work properly with the renamed window from warningDialog to MessageDialgo
  def initialize
    @title = Element.new("Popup Title", "{name='titleLabel' type='QLabel' visible='1' window=':MessageDialog_MessageDialog'}")

    #@text = Element.new("Popup Text", "{name='warningLabel' type='QLabel' visible='1' window=':WarningDialog_MessageDialog'}")
	

    # On some popups, the left button may not exist
    @rightBtn = Element.new("Right Button", "{name='rightButton' type='QPushButton' visible='1' window=':MessageDialog_MessageDialog'}")

    # left button on the popup may or may not exist
    if Squish::Object::exists("{name='leftButton' type='QPushButton' visible='1' window=':WarningDialog_MessageDialog'}")
      @leftBtn = Element.new("Left Button", "{name='leftButton' type='QPushButton' visible='1' window=':MessageDialog_MessageDialog'}")
    end

    @closeBtn = Element.new("Close(X) Button", "{name='closeButton' type='QPushButton' visible='1' window=':MessageDialog_MessageDialog'}")
    @captureScreenBtn = Element.new("Capture Screen Button", "{name='captureScreenButton' type='QPushButton' visible='1' window=':MessageDialog_MessageDialog'}")

    @elementList = [@title,  @rightBtn, @closeBtn, @captureScreenBtn]

    # add left button if it exists
    (@elementList << @leftBtn) if @leftBtn
  end
  
  def onScreen?
    Squish::Object::exists("  :MessageDialog.dialogContainer_QWidget")
  end


  def verifyPopupInformation(title, text)
    verifyElementsPresent(@elementList, self.class.name)
    verifyPopupText(text)
    verifyPopupTitle(title)

    return self
  end

  def clickBtn(name)
    if (btn = findElementByText(name))
      Test.log("#{self.class.name}::#{__method__}: Clicking button: '#{name}' ")
      click(btn)
    else
      Test.fail("#{self.class.name}::#{__method__}: Failed to find #{name} button")
    end

    return self
  end
  
  def getTitle
    return @title.getText
  end

  def getText
    return @title.getText
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