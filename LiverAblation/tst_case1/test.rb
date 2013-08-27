# encoding: UTF-8
require 'squish'


include Squish

require findFile("scripts", "MainScreen.rb")
require findFile("scripts", "ScreenObject.rb")
require findFile("scripts", "Element.rb")
require findFile("scripts", "TestLogger.rb")


def main

  startApplication("LiverAblation")
  
  #logFile = TestLogger.new("fromRubyMine")
  #logFile.AppendLog("Here's a command")
  #logFile.AppendLog("Some other crazy shit shere")
  #logFile.CompleteLog()
  #logFile.setInitialLogFile()
  logFile = TestLogger.new("tst_Case1")
  test = MainScreen.new(logFile).searchforRecord()
  
  
  
   
end


