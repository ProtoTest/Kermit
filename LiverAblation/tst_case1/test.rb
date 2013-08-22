# encoding: UTF-8
require 'squish'


include Squish

require findFile("scripts", "MainScreen.rb")
require findFile("scripts", "ScreenObject.rb")
require findFile("scripts", "Element.rb")
require findFile("scripts", "TestLogger.rb")


def main

  startApplication("LiverAblation")
  
  logFile = TestLogger.new("testOne")
  logFile.AppendLog("Here's a command")
  logFile.AppendLog("Some other crazy shit shere")
  #logFile.setInitialLogFile()
  #test = MainScreen.new
  #test.searchforRecord()
   
end


