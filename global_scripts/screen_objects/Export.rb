# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "kermit_core\\Element.rb")
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")
require findFile("scripts", "screen_objects\\ExportSnapshotsPopup.rb")

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
  attr_reader :appHeaderFooter

  def initialize
    # application header and footer for specifically edit screens
    @appHeaderFooter = AppHeaderFooterEdit.new

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

  # Clicks on the 'Export Snapshots to USB' and sets the folder name(if defined)
  # Params: folderName - Folder name string (optional)
  def ExportToUSB(folderName=nil)
    @exportSnapshotsBtn.click
    exportPopup = ExportSnapshotsPopup.new.saveSnapshots(folderName)
  	return self
  end

  def clickFinish
    @appHeaderFooter.clickNextButton
    return Export.new
  end

  def clickAddAblationZones
    @appHeaderFooter.clickBackButton
    return EditAblation.new
  end

end