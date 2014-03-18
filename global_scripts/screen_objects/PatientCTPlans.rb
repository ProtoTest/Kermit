require findFile("scripts", "kermit_core\\Element.rb")
require findFile("scripts", "screen_objects\\WarningDialogPopup.rb")

########################################################################################
#
#  Cat Scan Row component
#   Stores object elements of the CT row for a patient
#
#  @author Matt Siwiec
#  @notes Inherits from Element
#
########################################################################################
class CTRow < Element
  attr_reader :createPlanButton, :type

  def initialize(objectString)
    super("PatientRow", objectString)

    #CT Row Children
      #QHboxLayout, iconLabel, modalityLabel(type), dateLabel, imageCountLabel, compatibilityLabel, ratingLabel, infoLabel(link), newPlanButton

    objectChildren = getChildren

    if objectChildren
      # For elements whose text changes, need to use the real object name
      @icon = Element.new("Row Icon Label", ObjectMap.symbolicName(objectChildren[1]))
      @type = Element.new("Row_Type_Label", ObjectMap.symbolicName(objectChildren[2]))
      @date = Element.new("Date Label", ObjectMap.symbolicName(objectChildren[3]))
      @imageCountLabel = Element.new("Image Count Label", ObjectMap.symbolicName(objectChildren[4]))
      @compatibilityLabel = Element.new("Compatibility Label", ObjectMap.symbolicName(objectChildren[5]))
      @ratingLabel = Element.new("Rating Label", ObjectMap.symbolicName(objectChildren[6]))
      @createPlanButton = Element.new("Create New Plan Button", ObjectMap.symbolicName(objectChildren[7]))
    else
      raise "Failed to find any children within this CT Row"
    end
  end

  # override base class dClick. Doing this b/c the test to time opening the CT scan
  # is wasting ~1000+ milliseconds on moving the mouse to click on the center of the row
  def dClick
    # double click the date label instead
    @date.dClick
  end

  def saveCompatibilitySnapshot(filename)
    @compatibilityLabel.click
    screenshotButton = Element.new("ScreenShot Button","{name='captureScreenButton' type='QPushButton' visible='0' window=':CompatibilityDialog_CompatibilityDialog'}")
    screenshotButton.click
    ScreenCapturePopup.new.saveScreenshot(filename)
  end

  def getImageCount
    return @imageCountLabel.getText
  end
end

########################################################################################
#
#  Plan Row component
#   Stores object elements of a Plan row for a patient
#
#  @author Matt Siwiec
#  @notes Inherits from Element
#
########################################################################################
class PlanRow  < Element
  attr_reader :type
  def initialize(objectString)

    super("PlanRow", objectString)

    #Plan Row Children
      #QHboxLayout, iconLabel, planLabel(type), dateLabel, planStausLabel, planStatusContentsLabel,
      #byLabel, byContentsLabel, openPlanButton

    objectChildren = getChildren

    if objectChildren
      @icon = Element.new("Row Icon Label", ObjectMap.symbolicName(objectChildren[1]))
      @type = Element.new("Row_Type_Label", ObjectMap.symbolicName(objectChildren[2]))
      @date = Element.new("Date Label", ObjectMap.symbolicName(objectChildren[3]))
      @byLabel = Element.new("Info Link", ObjectMap.symbolicName(objectChildren[4]))
      @byContentsLabel = Element.new("Info Link", ObjectMap.symbolicName(objectChildren[5]))
      @openPlanButton = Element.new("Button", ObjectMap.symbolicName(objectChildren[6]))
    else
      raise "Failed to find any children within this CT Row"
    end
  end

  # Deletes the plan
  def delete
    self.click

    Log.Trace("Fucking Attempting to type <Delete> on #{self.symbolicName.to_s}")
    # Send the Delete key
    type( waitForObject(self.symbolicName), "<Delete>" )
    snooze 1
    Log.Trace("Fucking type'd <Delete>")

    # Select the 'Delete' button from the warning dialog
    popup = WarningDialogPopup.new
    popup.clickBtn("Delete")
  end

  # Opens up the plan
  def openPlan
    @openPlanButton.click
  end
end

# Factory class to return either a CT row or a PLAN row
class RowFactory
  def RowFactory.create(objectString)
    begin
      row = Element.new("Patient Table Row", objectString)

      # ensure the row is on the screen and displayed
      waitForObject(objectString, 500)

      # Grab the children for the object
      objectChildren = row.getChildren

      # The row type (either CT or PLAN)
      rowType = Element.new("Patient Row Type", ObjectMap.symbolicName(objectChildren[2]))

      if rowType.getText.eql?("CT")
        Log.Trace("#{self.class.name}::#{__method__}(): Returning a CTRow Object")
        return CTRow.new(objectString)
      elsif rowType.getText.eql?("PLAN")
        Log.Trace("#{self.class.name}::#{__method__}(): Returning a PlanRow Object")
        return PlanRow.new(objectString)
      else
        raise "Row Type text is #{rowType.getText}"
      end
    rescue Exception => e
      raise "Failed to determine whether or not '#{objectString}' is a CT or PLAN row: #{e.message}"
    end
  end
end

# Container class that is storing one CT with associated plans for the CT
class PatientCTPlans < Element
  attr_reader :ct, :plans

  def initialize(ct=nil)
    @ct = ct if not ct.nil?
    @plans = Array.new
  end

  def addCT(ct)
    if defined?(@ct)
      @ct = ct
    else
      raise "#{self.class.name}::#{__method__}(): A CT row has already been added"
    end
  end

  def addPlan(plan)
    @plans << plan
  end

  def deletePlan
    if @plans.first
      @plans.first.delete
      @plans.delete_at(0)
    end
  end

  def getPlanCount
    @plans.size
  end
end