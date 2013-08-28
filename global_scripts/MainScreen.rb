# encoding: UTF-8
require findFile("scripts", "Element.rb")
require findFile("scripts", "ScreenObject.rb")

class MainScreen < BaseScreenObject
  
  
  def initialize(logFile)
    @searchField = Element.new(":Form.search_QLineEdit")
    initLog(logFile)
  end
  
  def searchforRecord
    enterText(@searchField, "search text")
    return MainScreen
  end
end