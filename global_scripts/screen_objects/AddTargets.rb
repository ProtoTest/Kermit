# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "screen_objects\\AppHeaderFooterEdit.rb")
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")
require findFile("scripts", "screen_objects\\EditTarget.rb")


class AddTargets < BaseScreenObject
  def initialize
    @addTargetBtn = Element.new("Add a Target Button", ":Form.Add a Target_QPushButton")
    
    @appHeaderFooterEdit = AppHeaderFooterEdit.new

    @elements = [@addTargetBtn]
    verifyElementsPresent(@elements, self.class.name)
  end
  
  def clickAddTarget
    click(@addTargetBtn)
    snooze 1
    return EditTarget.new
  end
end