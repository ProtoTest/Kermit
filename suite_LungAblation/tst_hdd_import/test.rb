# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "kermit_core\\TestConfig.rb")
require findFile("scripts", "kermit_core\\Timer.rb")
require findFile("scripts", "screen_objects\\MainScreen.rb")
require findFile("scripts", "screen_objects\\PatientTable.rb")

def waitForHddTable
  patientContainer = Element.new("Patient Table Container", ":Form.customTreeWidget_CustomTreeWidget")
  # Should be 6, rather than 10, I think.
  waitFor('patientContainer.getChildren.size > 10', 90 * 1000)
end

class MainWithHdd < MainScreen
  def openHdd
    @hddBtn.click
    return MainWithHdd.new
  end
  def openSystem
    @systemBtn.click
    return MainWithHdd.new
  end
  def getPatientList
    # Dirty hack to avoid reloading each time patient list is retrieved.
    if defined? @initialized
      return @patientTable.patientList
    end
    waitForHddTable
    @patientTable = PatientTable.new
    @initialized = true
    return @patientTable.patientList
  end
end

def deleteErrything
  screen = MainScreen.new
  patientCount = screen.getPatientList
end


def main


  startApplication("LungAblation")
  Log.Trace("DOOP 22")

  # TestConfig
  installEventHandlers()



  #construct a page
  Log.Trace("DOOP 11")

  MainScreen.new.importPatients(:cd)

  # TODO - run through creating plans for every imported item.

  MainScreen.new.deletePatients

  completeTest

end