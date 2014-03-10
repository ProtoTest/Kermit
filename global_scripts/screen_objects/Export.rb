# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "kermit_core\\Common.rb")
require findFile("scripts", "kermit_core\\Element.rb")
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")
require findFile("scripts", "screen_objects\\ExportSnapshotsPopup.rb")
require findFile("scripts", "screen_objects\\WarningDialogPopup.rb")

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

    @exportSnapshotsStatusLabel = Element.new("Export Snapshots Status Label", "{container=':Form_ExportForm' name='exportMessageLabel' type='QLabel' visible='1'}")

    @elements = [@exportSnapshotsBtn]
    verifyElementsPresent(@elements, self.class.name)
  end

  # Clicks on the Capture Screen button in the application header,sets the filename, and whether
  # to include the patient details in the capture
  # Params: filename - optional filename to give the screenshot
  #         hidePatientDetails - to hide the patient information or not
  def captureScreen(filename=nil, hidePatientDetails=false)
    @appHeaderFooter.captureScreen(filename, hidePatientDetails)
    return self
  end

  # Clicks on the 'Export Snapshots to USB' and sets the folder name(if defined)
  # Params: folderName - Folder name string (optional)
  def exportToUSB(folderName=nil)
    # click the 'Export Snapshots' buttons
    @exportSnapshotsBtn.click

    # Check for the generic Warning Dialog popup indicating the USB drive is not plugged in
    while WarningDialogPopup.onScreen?
      @popup = WarningDialogPopup.new

      # check to see if the usb drive was not found
      usb_not_found_text = "No USB drive was found."

      popup_text = @popup.getText.strip
      popup_title = @popup.getTitle.strip

      if popup_title.eql?("Export Snapshots")
        # Check to see if the 'Export Snapshot' popup requires the user to enter a USB drive
        if popup_text.eql?(usb_not_found_text)
          send_email("Kermit Test Notification", "Please enter a USB drive into the computer and select OK on the dialog popup")
          message_dialog("USB Drive not found", "Please insert a USB drive and click OK")

          # clear the existing modal
          @popup.clickBtn("OK")

          # click export snapshot again
          @exportSnapshotsBtn.click
        end
      end
    end

    # Export the snapshots
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

  def verifyExportSuccessful
    text='Snapshots have been saved.'
    Log.TestVerify(text == @exportSnapshotsStatusLabel.getText , "Verify Export images to USB successful")
    return self
  end
end