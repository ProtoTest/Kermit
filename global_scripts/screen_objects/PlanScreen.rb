# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "kermit_core\\Element.rb")
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")
require findFile("scripts", "screen_objects\\EditTargetScreen.rb")

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
    
    # for these radio buttons, need to use real-property name minus the window property
    # This is because the Liver and Lung Application main window names differ
    # "Upslope_MainWindow" vs "Upslope Demo_MainWindow"
    @loadImagesBtn = Element.new("Load Images", "{name='backButton' text='Load Images' type='QPushButton' visible='1'}")
    @reviewBtn = Element.new("Review", "{name='nextButton' text='Review' type='QPushButton' visible='1'}")
  end
  
  def clickAddTarget
    click(@addTargetBtn)
    return EditTargetScreen.new
  end
end