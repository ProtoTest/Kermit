# encoding: UTF-8
require findFile("scripts", "Element.rb")
require findFile("scripts", "ScreenObject.rb")

class MainScreen < BaseScreenObject
  
  
  def initialize
    @searchField = Element.new(":Form.search_QLineEdit")
  end
  
  def searchforRecord
    enterText(@searchField, "search text")
    return MainScreen.new
  end
end