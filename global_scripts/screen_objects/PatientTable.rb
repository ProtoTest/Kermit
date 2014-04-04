# encoding: UTF-8
require 'squish'
include Squish

require findFile("scripts", "kermit_core\\Element.rb")
require findFile("scripts", "screen_objects\\BaseScreenObject.rb")
require findFile("scripts", "screen_objects\\AddTargets.rb")
require findFile("scripts", "screen_objects\\WarningDialogPopup.rb")
require findFile("scripts", "screen_objects\\PatientCTPlans.rb")

########################################################################################
#
#  Patient table header component
#     Stores object elements for the Patient table header
#
#  @author  Matt Siwiec
#  @notes 10/04/2013 - SU - Changed all BasePageObject clicks and dclicks to reference Element directly
#
########################################################################################
class TableHeader < BaseScreenObject

  def initialize
    # Table Headers
    @patientNameHeaderView = Element.new("Patient Name Table Header", ":Patient Name_HeaderViewItem")
    @patientIDHeaderView = Element.new("Patient ID Table Header", ":Patient ID_HeaderViewItem")
    @birthDateHeaderView = Element.new("Birth Date Table Header", ":Birth Date_HeaderViewItem")
    @lastAccessHeaderView = Element.new("Last Accessed Table Header", ":Last Accessed_HeaderViewItem")
  end

  def clickPatientHeader
    @patientNameHeaderView.click
  end

  def clickPatientIDHeader
    @patientIDHeaderView.click
  end

  def clickBirthDateHeader
    @birthDateHeaderView.click
  end

  def clickLastAccessHeader
    @lastAccessHeaderView.click
  end
end


########################################################################################
#
#  Patient Details
#     Stores the object elements for a Patient's CT and plan rows
#
#     Does not currently handle multiple CT rows.
#
#  @author    Matt Siwiec
#  @notes     In order to get access to the rows objects (CT's and Plans), the patient name must be 'clicked'
#             to open the sub-tree of patient details
#
#   Basically an array of multiple CT's and associated array of plans:
#     patientDetails = [ [ct, [plans], [ct, [plans] ]
#
#
########################################################################################
class PatientDetails < BaseScreenObject
  attr_reader :patientCTPlans

  def initialize
    # Array of patient CTs and plans
    # Each element in the array has a PatientCTPlans object containign ONE CT and multiple plans created for that CT
    @patientCTPlans = Array.new
    initPatientCTsAndPlans
  end

  # Clicks on the create new plan button
  def clickCreateNewPlan
    Log.Trace(@patientCTPlans.first.ct.createPlanButton.to_s)
    Log.Trace(@patientCTPlans.first.ct.createPlanButton.onScreen?.to_s)
    @patientCTPlans.first.ct.createPlanButton.click
	  return AddTargets.new
  end

  # Double clicks the patient's CT scan to open it
  def openCT(timer=nil)
    timer.start if not timer.nil?
    @patientCTPlans.first.ct.dClick
    timer.stop if !timer.nil? && CTImageDisplayed?
  end

  # Verifies the CT image is displayed
  def CTImageDisplayed?
    begin
      waitForObject(":Form.qvtkWidget_QVTKWidget", OBJECT_WAIT_TIMEOUT)
      return true
    rescue Exception => e
      return false
    end
  end

  # Returns the total count of plans for all of the patient CT's
  def getPlanCount
    num_plans = 0

    @patientCTPlans.each do |ct_plan|
      num_plans += ct_plan.plans.count
    end
    return num_plans
  end

  # Returns the count of CTs for the patient
  def getCTCount
    return @patientCTPlans.size
  end


############################### PRIVATE FUNCTIONALITY ####################################

  private

  #
  # Returns an array of the CT/Plan container objects for the patient
  #
  ## For each addtional row in patientdetails (could be a CT row or a Plan row)
  #   Initialze the data stucture (CTAndPlans - 1 CT, multiple Rows)
  #   Send the object string up to the row factory and return a CT or Plan row // row = RowFactory(realObjectString)
  #   If the class returned is CTRow
  #     Create a new CTPlans class (initialize it with the CT row), add it to the CTPlans array collection
  #   Else the class return is PlanRow
  #     Add the PlanRow to the CTPlans class (last element in the CTPlans array collection)
  #   End
  # end
  def initPatientCTsAndPlans
    rows = Array.new
    startIndex = 2

    # There MUST be at least ONE CT for a patient in the database
    ct = RowFactory.create("{container=':Form.customTreeWidget_CustomTreeWidget' name='frame' type='QFrame'  visible='1'}")
    raise "Failed to verify the patient has at least one CT" if not ct.class.eql?(CTRow)
    patient_ct_and_plans = PatientCTPlans.new(ct)

    # add the ct/plan object to the patient details list
    @patientCTPlans << patient_ct_and_plans

    begin
      # loop through the rest of the list of patient rows
      begin
        # each patient plan row is indexed via the 'occurrence' property
        row_real_name = "{container=':Form.customTreeWidget_CustomTreeWidget' name='frame' occurrence='%s' type='QFrame'  visible='1'}" % startIndex

        # send the row through the Factory and get a CTRow or a PlanRow
        row = RowFactory.create(row_real_name)

        # add the plan to the container, if it is a plan row
        patient_ct_and_plans.addPlan(row)  if row.class.eql?(PlanRow)

        # Create a new PatientCTPlans object if the row is a CT row
        if row.class.eql?(CTRow)
          # new CT and set of plans
          patient_ct_and_plans = PatientCTPlans.new(row)

          # add the ct/plan object to the patient details list
          @patientCTPlans << patient_ct_and_plans
        end

        startIndex += 1

      end while (1)
    rescue Exception => e
      # no more rows, save the CT and plans to the list
    end

    Log.Trace("#{self.class.name}::#{__method__}(): Parsed CT and Plans for patient")
  end

end

########################################################################################
#
#  Patient
#     Stores a reference to the patient element object
#
#  @author    Matt Siwiec
#  @notes     Provides functionality for the tester to get the patient details from the sub-tree
#	10/04/2013 SethUrban Changed all clicks and dclicks to reference element instead of BasePageObject
#
########################################################################################
class Patient < BaseScreenObject
  attr_reader :name, :id, :birthDate, :lastAccessed

  def initialize(patient_info_array, objectString)
    @name = patient_info_array[0]
    @id = patient_info_array[1]
    @birthDate = patient_info_array[2]
    @lastAccessed = patient_info_array[3]

    @patientElement = Element.new(name, objectString)
  end

  def getProperties
    return Squish::Object.properties(waitForObject(@patientElement.symbolicName))
  end

  def onScreen?
    @patientElement.onScreen?
  end

  # Returns the patient details (CT Row, Plan Rows)
  def openPatientDetails
    @patientElement.click
    return PatientDetails.new
  end

  # Closes the tree for the patient
  def closePatientDetails
    @patientElement.click
  end

  # Opens up the patient's CT
  def openCTScan(timer=nil)
    openPatientDetails.openCT(timer)
  end

  # Opens up the patient's CT and times how long it takes to open it
  # Param: timer - the timer used to time request
  def openAndTimeCTScanImage(timer)
    openCTScan(timer)
    return AddTargets.new
  end

  def deletePatient
    begin
      details = openPatientDetails
      details.patientCTPlans[0].ct.delete
    end while details.patientCTPlans.size > 1

  end

  def to_s
    "Patient = [name:#{@name}, id:#{@id}, birthDate:#{@birthDate}, lastAccessed:#{@lastAccessed}]"
  end

end


########################################################################################
#
#  PatientTable
#     Stores the components of all patients in the table
#
#  @author  Matt Siwiec
#  @notes
#	10/04/13 - SU - Removed ScrollBar Class, changed to element class
#
########################################################################################
class PatientTable < BaseScreenObject
  attr_reader :patientList

  def initialize
    @tableHeader = TableHeader.new
    @patientList = getPatientList
    @scrollbar = Element.new("Patient Table Scroll bar", ":customTreeWidget_QScrollBar")
  end

  def scrollDown
    @scrollbar.scrollDown if @scrollbar.onScreen?
  end

  # scroll down to row in the table
  def scrollToRowByIndex(index)
	  Log.Trace("Scrolling down to index: #{index}")
	  Log.Trace("Scrolling #{(index/(MAX_NUM_VISIBLE_TABLE_ROWS-1)).to_i} times")
    if(index >= (MAX_NUM_VISIBLE_TABLE_ROWS-1))
      (index / (MAX_NUM_VISIBLE_TABLE_ROWS-1)).to_i.times do
        @scrollbar.scrollDown
      end
    end
  end

  def deletePatient(index)
    @patientList[index].deletePatient
    @patientList.delete_at(index)
  end

  # Returns the number of patients in the patient table
  def getPatientCount
    return @patientList.size
  end

############################### PRIVATE FUNCTIONALITY ####################################

  private

  # Returns the list of patients(Class.Patient) found within the container
  def getPatientList
    patientContainer = Element.new("Patient Table Container", ":Form.customTreeWidget_CustomTreeWidget")
    patientList = Array.new

    if children=patientContainer.getChildren
      children.each_with_index do |x, index|
        # if the colum is 0, then it is the patient name
        if x.respond_to?(:text) and x.respond_to?(:column) and (x.column==0)
          # If we are dynamically adding patients after they are loaded, the patient objects
          # need to be added to the Object Map
          # begin


          # Grab the patient ID, birthdate, last accessed and store it in the patient list. They are the
          # successive children after we found the patient name, which is 'x'
          patientID = children[index+1]
          birthdate = children[index+2]
          lastAccessed = children[index+3]
          # Assume we have never seen this patient before and add its element's symbolic name to Squish's object map.
          ObjectMap.add(patientID)
          patientList << Patient.new([x.text, patientID.text, birthdate.text, lastAccessed.text], ObjectMap.symbolicName(patientID))
        end
      end
    else
      Log.TestFail("#{self.class.name}::#{__method__}(): Failed to find any patients in the table")
    end

    return patientList
  end
end

