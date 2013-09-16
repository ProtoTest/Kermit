# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "Element.rb")
require findFile("scripts", "BaseScreenObject.rb")
require findFile("scripts", "EditTargetScreen.rb")
require findFile("scripts", "PlanScreen.rb")

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