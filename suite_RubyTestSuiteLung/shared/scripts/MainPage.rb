# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "MainContainer.rb")

class MainPage < MainContainerPage
  attr_reader :databaseButton, :cdButton, :usbButton, :hardDriveButton, :captureScreenButton, :searchBox
  attr_reader :patientNameHeaderView, :patientIDHeaderView, :birthDateHeaderView, :lastAccessHeaderView
  attr_reader :patient0
  
  def initialize
    Test.log("Initializing MainPage object")
    
    # initialize parent
    super
    
    # Buttons
    @databaseButton = Element.new(":Form.Database_QToolButton")
    @cdButton = Element.new(":Form.CD_QToolButton")
    @usbButton = Element.new(":Form.USB_QToolButton")
    @hardDriveButton = Element.new(":Form.Hard Drive_QToolButton")
    @captureScreenButton = Element.new(":Form.Capture Screen_QPushButton")
    
    # Text Entry
    @searchBox = TextInputElement.new(":Form.search_QLineEdit")
    
    # Table Headers
    @patientNameHeaderView = Element.new(":Patient Name_HeaderViewItem")
    @patientIDHeaderView = Element.new(":Patient ID_HeaderViewItem")
    @birthDateHeaderView = Element.new(":Birth Date_HeaderViewItem")
    @lastAccessHeaderView = Element.new(":Last Accessed_HeaderViewItem")
    # Table Data
    @patient0 = Element.new(":customTreeWidget.1.3.6.1.4.1.9328.50.3.0537_QModelIndex")
    
    def doShit(element)
      Test.log("MainPage::doShit: " + element.symName)
    end
    
  end
  
  
end
