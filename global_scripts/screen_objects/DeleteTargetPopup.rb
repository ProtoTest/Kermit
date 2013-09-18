# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "kermit_core\\Element.rb")
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")
require findFile("scripts", "screen_objects\\EditTargetScreen.rb")
require findFile("scripts", "screen_objects\\PlanScreen.rb")

class DeleteTargetPopup < BaseScreenObject
  def initialize
    @cancelBtn = Element.new("Cancel Button", ":WarningDialog.Cancel_QPushButton")
    @deleteBtn = Element.new("Delete Button", ":WarningDialog.Delete_QPushButton")
  end
  
  def clickCancel
    click(@cancelBtn)
    return EditTargetScreen.new
  end
  
  def clickDelete
    click(@deleteTargetBtn)
    return PlanScreen.new
  end
end