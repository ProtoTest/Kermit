# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "Element.rb")
require findFile("scripts", "BaseScreenObject.rb")

class EditAblationScreen < BaseScreenObject
  def initialize
    @saveAblationBtn = Element.new("Save Ablation Button", ":Form.Save Ablation Zone_QPushButton")
    @deleteAblationBtn = Element.new("Delete Ablation Button", ":Form.Delete Ablation Zone_QPushButton")
  end
  
  def clickSaveAblation
    click(@saveAblationBtn)
    return SetEntryPointScreen.new
  end
  
  def clickDeleteAblation
    click(@deleteAblationBtn)
    return EditTargetScreen.new
  end
end