# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "kermit_core\\Element.rb")
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")
require findFile("scripts", "screen_objects\\EditAblationScreen.rb")
require findFile("scripts", "screen_objects\\WarningDialogPopup.rb")

class EditTargetScreen < BaseScreenObject
  def initialize
    @saveTargetBtn = Element.new("Save Target Button", ":Form.Save Target_QPushButton")
    @deleteTargetBtn = Element.new("Delete Target Button", ":Form.Delete Target_QPushButton")
  end
  
  def clickSaveTarget
    click(@saveTargetBtn)
    snooze 1
    return EditAblationScreen.new
  end
  
  def clickDeleteTarget
    click(@deleteTargetBtn)
    snooze 1
    return WarningDialogPopup.new
  end
end