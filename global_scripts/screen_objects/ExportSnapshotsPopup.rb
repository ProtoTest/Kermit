require findFile("scripts", "kermit_core\\Element.rb")
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")

########################################################################################
#
#  Export Snapshots Popup
#     Contains all the elements for the Export Snapshots Dialog Popup. Exports all captured images
#     to the external USB
#
#  @author  Matt Siwiec
#
#
########################################################################################
class ExportSnapshotsPopup < BaseScreenObject
  TAG = "Export Snapshots Popup"

  def initialize
  	@closeBtn = Element.new("#{TAG}: Close Button", "{name='closeButton' type='QPushButton' visible='1' window=':ScreenCaptureDialog_ExportSnapshotDialog'}")
  	@folderNameTextField = Element.new("#{TAG}: Folder name text entry", "{name='folderNameEdit' type='QLineEdit' visible='1' window=':ScreenCaptureDialog_ExportSnapshotDialog'}")

  	@cancelBtn = Element.new("#{TAG}: cancel button", "{name='cancelButton' text='Cancel' type='QPushButton' visible='1' window=':ScreenCaptureDialog_ExportSnapshotDialog'}")
  	@exportBtn = Element.new("#{TAG}: save button", "{name='exportButton' text='Export' type='QPushButton' visible='1' window=':ScreenCaptureDialog_ExportSnapshotDialog'}")

  	@elements = [@closeBtn, @folderNameTextField, @cancelBtn, @exportBtn]

  	verifyElementsPresent(@elements, self.class.name)
  end

  # Saves all captured screenshots to USB drive
  # Param: folder - The folder name to give to screen shot (optional)
  def saveSnapshots(folderName=nil)
  	@@logFile.TestLog("Saving screenshots to '#{folderName}.png'")
  	@folderNameTextField.enterText(folderName) if folderName
  	clickExport
  end

  def clickExport
  	@exportBtn.click
  end

  def clickCancel
  	@cancelBtn.click
  end

end
