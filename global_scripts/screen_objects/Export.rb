# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "screen_objects\\BaseScreenObject.rb")

########################################################################################
#
#  Export
#     This is the Export screen
#
#  @author  Matt Siwiec
#
########################################################################################

#This is the status bar presented along the bottom of the screens i.e. Footer
class Export < BaseScreenObject
  def initialize
  	@exportSnapshotsBtn = Element.new("Export Snapshots to USB Button", ":Form.Export Snapshots to USB_QPushButton")
  end

  # Clicks on the Capture Screen button in the application header,sets the filename, and whether
  # to include the patient details in the capture
  # Params: filename - name to give the screenshot
  #         hidePatientDetails - to hide the patient information or not
  def captureScreen(filename, hidePatientDetails=false)
    super(filename, hidePatientDetails)
    return self
  end

  def clickExportToUSB
  	@exportSnapshotsBtn.click
  	return Export.new
  end

  def clickFinish
    @appHeaderFooterEdit.clickNextButton
    return Export.new
  end

  def clickAddAblationZones
    @appHeaderFooterEdit.clickBackButton
    return EditAblation.new
  end

end