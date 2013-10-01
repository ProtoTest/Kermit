# this is an extension of the AppHeaderFooter screen within the Edit screens

require findFile("scripts", "screen_objects\\AppHeaderFooter.rb")

class AppHeaderFooterEdit < AppHeaderFooter
  def initialize
  	# intialize parent class
    super

    # The text of these buttons changes depending on what screen you are in, or they may not be visible at all
    @backBtn = Element.new("Back Button", "{name='backButton' type='QPushButton' visible='1' window=':_MainWindow'}")
    @nextBtn = Element.new("Next Button", "{name='nextButton' type='QPushButton' visible='1' window=':_MainWindow'}")
  end

  def clickBackButton
    click(@backBtn)
  end

  def clickNextButton
    click(@nextBtn)
  end
end