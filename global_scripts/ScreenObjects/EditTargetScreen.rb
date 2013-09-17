# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "Element.rb")
require findFile("scripts", "BaseScreenObject.rb")
require findFile("scripts", "EditAblationScreen.rb")
require findFile("scripts", "DeleteTargetPopup.rb")

class EditTargetScreen < BaseScreenObject
  def initialize
    @saveTargetBtn = Element.new("Save Target Button", ":Form.Save Target_QPushButton")
    @deleteTargetBtn = Element.new("Delete Target Button", ":Form.Delete Target_QPushButton")
  end
  
  def clickSaveTarget
    click(@saveTargetBtn)
    return EditAblationScreen.new
  end
  
  def clickDeleteTarget
    click(@deleteTargetBtn)
    return DeleteTargetPopup.new
  end
end