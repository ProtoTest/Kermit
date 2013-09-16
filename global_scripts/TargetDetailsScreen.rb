# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "Element.rb")
require findFile("scripts", "BaseScreenObject.rb")

class TargetDetailsScreen < BaseScreenObject
  def initialize
    @titleLabel = Element.new("Title Label", ":Form.Volume Rendering_QLabel")
    verifyTextDetails
  end
  
  def verifyTextDetails
      Test.verify("Volume Rendering" == @titleLabel.getProperty('text'), "Target Details title is 'Volume Rendering'")
  end
end
