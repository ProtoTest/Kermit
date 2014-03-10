
##################################################
# Seth Urban - 09/05/13
# This is the template class where child classes will be instantiated from
# containing all the basic API functionality from SQUISH that to be abstracted from the
# test engineer.
##################################################

class BaseScreenObject

  # Takes a list of elements and verifies the objects are present and visible
  def verifyElementsPresent(elementList, screenName, timeout = 10000)
    elementList.each do |element|
      begin
        waitForObject(element.symbolicName, timeout)
      rescue Exception => e
        Log.TestFail("#{self.class.name}::#{__method__}(): Failed to verify '#{element.name}' is present in screen #{screenName}")
      end
    end
  end
end
