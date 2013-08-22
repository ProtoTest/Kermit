# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "Element.rb")

class MainContainerPage
  attr_reader :closeButton, :minimizeButton, :loadImagesButton, :planButton, :reviewButton
  attr_reader :logoLabel
  
  def initialize
    Test.log("Initializing MainContainerPage object")
  
    # Buttons
    @closeButton = Element.new(":Form.closeButton_QPushButton")
    @minimizeButton = Element.new(":Form.minimizeButton_QPushButton")
    @loadImagesButton = Element.new(":Upslope.Load Images_QPushButton")
    @planButton = Element.new(":Upslope.Plan_QPushButton")
    @reviewButton = Element.new(":Upslope.Review_QPushButton")
    
    # Labels
    @logoLabel = Element.new(":Form.logo_QLabel")
  end
end