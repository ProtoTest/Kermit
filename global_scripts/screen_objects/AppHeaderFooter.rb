# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "screen_objects\\BaseScreenObject.rb")

module RadioButtons
  LOAD_IMAGES = 1
  ADD_TARGETS = 2
  ADD_ABLATION = 3
  EXPORT = 4
end

########################################################################################
#
#  AppHeaderFooter
#     This is the standard App Header footer used for all the screens on the application
#
#  @author  Matt Siwiec
#  @notes -10/04/2013 - SU - Changed all BasePageObject clicks and dclicks to reference Element directly
#
########################################################################################

#This is the status bar presented along the bottom of the screens i.e. Footer
class StatusBar < BaseScreenObject

  def initialize(objectString)
    # use the container object string to get the children
    @container = Element.new("Status Bar container", objectString)
    objectChildren = @container.getChildren

    # skip over the children who are line seperator QFrames
    # elements that are not using the children array are elements whose text can change
    @procedureLabel = Element.new("Procedure Label", ObjectMap.symbolicName(objectChildren[0]))
    @procedure = Element.new("Procedure", ObjectMap.symbolicName(objectChildren[1]))
    @userLabel = Element.new("User Label", ObjectMap.symbolicName(objectChildren[3]))
    @user = Element.new("User", ObjectMap.symbolicName(objectChildren[4]))
    @networkStatusLabel = Element.new("Network Status Label", ObjectMap.symbolicName(objectChildren[6]))
    @networkStatus = Element.new("Network Status", "{container=':Form_StatusBarForm' name='networkStatusLabel2' type='QLabel' visible='1'}")
    @powerSourceLabel = Element.new("Power Source Label", ObjectMap.symbolicName(objectChildren[9]))
    @powerSource = Element.new("Power Source", "{container=':Form_StatusBarForm' name='powerSourceLabel2' type='QLabel' visible='1'}")
    @versionLabel = Element.new("Version Label", ObjectMap.symbolicName(objectChildren[12]))
    @version = Element.new("Version", ObjectMap.symbolicName(objectChildren[13]))
    @date = Element.new("Date", "{container=':Form_StatusBarForm' name='dateLabel' type='QLabel' visible='1'}")
    @time = Element.new("Time", "{container=':Form_StatusBarForm' name='timeLabel' type='QLabel' visible='1'}")

    # doing this with elements to make the code easier to read by not having all of them on one line
    @elements = [ @procedureLabel, @procedure, @userLabel, @user, @networkStatusLabel, @networkStatus,
                  @powerSourceLabel, @powerSource, @versionLabel, @version, @date, @time ]

    verifyElementsPresent(@elements, self.class.name)
  end
end

#This is the applicatoin header and footer presented at the top and bottom of the screen
class AppHeaderFooter < BaseScreenObject

  def initialize
    # Buttons
    @closeBtn = Element.new("Close Button", ":Form.closeButton_QPushButton")

    # for these radio buttons, need to use real-property name minus the window property
    # This is because the Liver and Lung Application main window names differ
    # "Upslope_MainWindow" vs "Upslope Demo_MainWindow" --- TODO, maybe not anymore with window being mainwindow now
    @loadImagesRadio = Element.new("Load Images Radio", "{text='Load Images' type='QPushButton' unnamed='1' visible='1' window=':_MainWindow'}")
    @addTargetsRadio = Element.new("Plan Radio", "{text='Add Targets' type='QPushButton' unnamed='1' visible='1' window=':_MainWindow'}")
    @addAblationRadio = Element.new("Review Radio", "{text='Add Ablation Zones' type='QPushButton' unnamed='1' visible='1' window=':_MainWindow'}")
    @exportRadio = Element.new("Export Radio Button", "{text='Export' type='QPushButton' unnamed='1' visible='1' window=':_MainWindow'}")

    @elements = [@closeBtn, @loadImagesRadio, @addTargetsRadio, @addAblationRadio, @exportRadio]
    verifyElementsPresent(@elements, self.class.name)
  end

  def clickLoadImagesRadio
    return clickRadio(RadioButtons::LOAD_IMAGES)
  end

  def clickAddTargetsRadio
    return clickRadio(RadioButtons::ADD_TARGETS)
  end

  def clickAddAblationZonesRadio
    return clickRadio(RadioButtons::ADD_ABLATION)
  end

  def clickExportRadio
    return clickRadio(RadioButtons::EXPORT)
  end

############################### PRIVATE FUNCTIONALITY ####################################

  private

  # Clicks on the radio button represented by param radioBtnModuleID
  def clickRadio(radioBtnModuleID)
    case radioBtnModuleID
    when RadioButtons::LOAD_IMAGES
      @loadImagesRadio.click
    when RadioButtons::ADD_TARGETS
      @addTargetsRadio.click
      return AddTargets.new
    when RadioButtons::ADD_ABLATION
      @addAblationRadio.click
      return AddAblationZones.new
    when RadioButtons::EXPORT
      @exportRadio.click
      return Export.new
    else
      @@logFile.TestFail("#{self.class.name}::#{__method__}(): Invalid radio button ID")
    end
  end
end
