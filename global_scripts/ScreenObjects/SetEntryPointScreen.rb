# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "Element.rb")
require findFile("scripts", "BaseScreenObject.rb")
require findFile("scripts", "SetEntryPointScreen.rb")
require findFile("scripts", "TargetDetailsScreen.rb")

class SetEntryPointScreen < BaseScreenObject
  def initialize
    @saveEntryBtn = Element.new("Save Entry Point Button", ":Form.Save Entry Point_QPushButton")
    @deleteEntryBtn = Element.new("Delete Entry Point Button", ":Form.Delete Entry Point_QPushButton")
  end
  
  def clickSaveEntryPoint
    click(@saveEntryBtn)
    return TargetDetailsScreen.new
  end
  
  def clickDeleteEntryPoint
    click(@deleteEntryBtn)
    return EditAblationScreen.new
  end
end