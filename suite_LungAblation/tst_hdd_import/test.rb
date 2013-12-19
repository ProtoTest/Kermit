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
    #return MainWithHdd.new
  end
  def openSystem
    @systemBtn.click
    return MainWithHdd.new
  end
  def getPatientList
    # Dirty hack to avoid reloading each time patient list is retrieved.
    if defined? @table_reloaded 
      return @patientTable.patientList
    end
    waitForHddTable
    @patientTable = PatientTable.new
    @table_reloaded = true
    return @patientTable.patientList
  end
end

def deleteErrything
  screen = MainScreen.new
  patientCount = screen.getPatientList
end


def main


  startApplication("LungAblation")

  # TestConfig
  installEventHandlers()


  #construct a page

  # @@logFile.Trace(ObjectMap.realName("blahrasdf"))

  mainScreen = MainWithHdd.new

  mainScreen.openHdd
  hddScreen = MainWithHdd.new
  @@logFile.Trace("RAAAWERAWERAWERAWERWAER")
  patientList = hddScreen.getPatientList
  hddListSize = patientList.size
  screen = hddScreen.openSystem

  (0...hddListSize).each do |index|
    screen.openHdd
    waitForHddTable
    hddScreen.patientTable.scrollToRowByIndex(index)
    patient = hddScreen.getPatientList[index]
    @@logFile.Trace("Just selected patient with id %s" % patient.id)
    # begin
    details = patient.openPatientDetails
    #details.CTRow.saveCompatibilitySnapshot("SCREEN_%s" % patient.id)
    # rescue
    #   hddScreen.captureScreen("Failed click")
    # Double click the CTRow to import it.
    # This currently only imports one CT series, but patients can have multiple series.
    details.CTRow.dClick
  end

  mainScreen = MainScreen.new
  patientCount = mainScreen.getPatientList.size
  (0...patientCount).each do |i|

    @@logFile.Trace("Deleting patient %s" % mainScreen.getPatientList[0].to_s)
    mainScreen.patientTable.deletePatient(0)
  end

  completeTest

end