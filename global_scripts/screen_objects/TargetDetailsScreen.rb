# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "kermit_core\\Element.rb")
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")

class TargetDetailsScreen < BaseScreenObject
  def initialize
    @titleLabel = Element.new("Title Label", ":Form.Volume Rendering_QLabel")

    @elements = [@titleLabel]
    verifyScreenObjects
  end
  

  def verifyScreenObjects
  	verifyElementsPresent(@elements)
    verifyTextDetails
  end

  def verifyTextDetails
      Test.verify("Volume Rendering" == @titleLabel.getProperty('text'), "Target Details title is 'Volume Rendering'")
  end
end
