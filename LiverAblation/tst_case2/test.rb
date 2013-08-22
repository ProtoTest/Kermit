def main
  startApplication("LungAblation")
  
  closeButton = Element.new(":Form.closeButton_QPushButton")
  Test.log("#{closeButton.realName}")
  Test.log("#{closeButton.symName}")
  Test.log("#{closeButton.getProperty('text')}")
  patientLabel = Element.new(":Patient Name_HeaderViewItem")

  Test.log("#{patientLabel.realName}")
  Test.log("#{patientLabel.symName}")
  Test.log("#{patientLabel.getProperty('text')}") if not patientLabel.getProperty('text').nil?
  closeButton.click  
end