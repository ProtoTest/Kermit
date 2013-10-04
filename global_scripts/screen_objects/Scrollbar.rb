##Commented out this class - Moved functions to element class
##Changed referances to Scrollbar in PatientTable class to use element instead

# class Scrollbar < Element
  # def initialize(name, objectString)
  	# super(name, objectString)
  # end

  # def scrollUp
  	# h = getProperty('height')
    # w = getProperty('width')
    # mouseClick(symbolicName, w/2, 20, 0, Qt::LEFT_BUTTON)
  # end

  # def scrollDown
  	# h = getProperty('height')
    # w = getProperty('width')
    # mouseClick(symbolicName, w/2, h-20, 0, Qt::LEFT_BUTTON)
  # end
# end