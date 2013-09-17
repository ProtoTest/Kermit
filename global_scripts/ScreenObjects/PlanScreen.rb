# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "Element.rb")
require findFile("scripts", "BaseScreenObject.rb")
require findFile("scripts", "EditTargetScreen.rb")

class Toolbox < Element

  def initialize
    super("Toolbox dropdown button", ":Form.Toolbox_QPushButton")
  end
  
  def opened?
    getProperty("checked")
  end
end

class PlanScreen < BaseScreenObject
  def initialize
    @addTargetBtn = Element.new("Add Target", ":Form.Add a Target_QPushButton")
    @changeViewBtn = Element.new("Change View", ":Form.Change Views_QPushButton")
    @captureScreenBtn = Element.new("Capture Screen", ":Form.Capture Screen_QPushButton_2")
    @loadImagesBtn = Element.new("Load Images", ":Upslope.Load Images_QPushButton_2")
    @reviewBtn = Element.new("Review", ":Upslope.Review_QPushButton_2")
  end
  
  def clickAddTarget
    click(@addTargetBtn)
    return EditTargetScreen.new
  end
end