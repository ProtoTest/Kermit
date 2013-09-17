# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "Element.rb")

class AppHeaderFooter
  attr_reader :closeButton, :minimizeButton, :loadImagesRadio, :planRadio, :reviewRadio
  attr_reader :logoLabel
  
  def initialize
 
    # Buttons
    @closeButton = Element.new("Close Button", ":Form.closeButton_QPushButton")
    @minimizeButton = Element.new("Minimize Button", ":Form.minimizeButton_QPushButton")
    
    # for these radio buttons, need to use real-property name minus the window property
    # This is because the Liver and Lung Application main window names differ
    # "Upslope_MainWindow" vs "Upslope Demo_MainWindow"
    @loadImagesRadio = Element.new("Load Images Radio", "{name='firstTaskButton' text='Load Images' type='QPushButton' visible='1'}")
    @planRadio = Element.new("Plan Radio", "{name='middleTaskButton' text='Plan' type='QPushButton' visible='1'}")
    @reviewRadio = Element.new("Review Radio", "{name='lastTaskButton' text='Review' type='QPushButton' visible='1'}")
   
    # Labels
    @logoLabel = Element.new("Logo Label", ":Form.logo_QLabel")
  end
end
