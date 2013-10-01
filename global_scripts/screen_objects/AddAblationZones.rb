# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "screen_objects\\AppHeaderFooterEdit.rb")
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")
require findFile("scripts", "screen_objects\\EditAblation.rb")

class AddAblationZones < BaseScreenObject
  def initialize
  	@addAblationBtn = Element.new("Add Ablation Zone button", ":Form.Add Ablation Zone_QPushButton")
  	@appHeaderFooterEdit = AppHeaderFooterEdit.new

    @elements = [@addAblationBtn]
    verifyElementsPresent(@elements, self.class.name)
  end

  def clickAddAblation
  	click(@addAblationBtn)
  	return EditAblation.new
  end
end