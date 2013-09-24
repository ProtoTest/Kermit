# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "kermit_core\\Element.rb")
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")
require findFile("scripts", "screen_objects\\SetEntryPointScreen.rb")
require findFile("scripts", "screen_objects\\TargetDetailsScreen.rb")

class SetEntryPointScreen < BaseScreenObject
  def initialize
    @saveEntryBtn = Element.new("Save Entry Point Button", ":Form.Save Entry Point_QPushButton")
    @deleteEntryBtn = Element.new("Delete Entry Point Button", ":Form.Delete Entry Point_QPushButton")
  end
  
  def clickSaveEntryPoint
    click(@saveEntryBtn)
    snooze 1
    return TargetDetailsScreen.new
  end
  
  def clickDeleteEntryPoint
    click(@deleteEntryBtn)
    snooze 1
    return EditAblationScreen.new
  end
end