# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "Element.rb")

class AppHeaderFooter
  attr_reader :closeButton, :minimizeButton, :loadImagesRadio, :planRadio, :reviewRadio
  attr_reader :logoLabel
  
  def initialize
    Test.log("Initializing MainContainerPage object")
  
    # Buttons
    @closeButton = Element.new("Close Button", ":Form.closeButton_QPushButton")
    @minimizeButton = Element.new("Minimize Button", ":Form.minimizeButton_QPushButton")
    @loadImagesRadio = Element.new("Load Images Radio", ":Upslope.Load Images_QPushButton")
    @planRadio = Element.new("Plan Radio", ":Upslope.Plan_QPushButton")
    @reviewRadio = Element.new("Review Radio", ":Upslope.Review_QPushButton")
    
    # Labels
    @logoLabel = Element.new("Logo Label", ":Form.logo_QLabel")
  end
end