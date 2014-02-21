# encoding: UTF-8
require 'squish'
require 'fileutils'

include Squish

require findFile("scripts", "kermit_core\\Common.rb")
require findFile("scripts", "kermit_core\\Env.rb")
require findFile("scripts", "kermit_core\\HTML_LogGenerator.rb")

########################################################################################
#
#  Test Logger
#     Used to certify the actions of a particular test as it happens and build HTML output log incorporating screenshots
#     Additionally, cpu and memory usage are recorded at the time of each log event, and included in the HTML output log.
#
#  @author  Seth Urban
#  @notes -10/04/2013 - SU - Wrapped squish Test.functions to allow to copy them to the log and present them as output
#
########################################################################################

class TestLogger
  attr_reader :testLogLocation
  attr_reader :fileName
  attr_reader :testName

  def initialize
    @testLogLocation = ENV['USERPROFILE'] + "\\Documents\\SquishTestLogs\\"
    @testName = getTestName()
    @fileType = ".txt"
    @fileName = ""
    @seperator = ":**:"
    @testInfo = ""

    setInitialLogFile()

    @@screenshotCount = 0

  end

  def setInitialLogFile
    # create the root user directory to store all log directories
    Dir.mkdir(@testLogLocation) if not File.exist?(@testLogLocation)

    now = Time.new
    @testLogLocation += @testName + "_" + now.strftime("%Y_%m_%d-%I_%M_%S") + "\\"
    @testName +=  now.strftime("_%I_%M_%S")
    Dir.mkdir(@testLogLocation)
    #after the testName has been identified above build the full filepath string again in case testName was changed
    @fileName = @testLogLocation + @testName + @fileType

    #write the file
    #@testInfo = TestInfo() #this will only work from within squish
    @Header = "TEST COMMAND\t\tSCREENSHOT\t\tUSED MEMORY\t\tTOTAL CPU USAGE\t\tTIME\n-------------------------------------------------------------------------------------------------------"
    @testlog = File.open(@fileName, "w")
    @testlog.puts(@Header)
  end

  def AppendLog(command, screenShot = "ns")

    now = Time.new
    #builds a string out of dates for logging
    timeDel = "."
    nowString = now.day.to_s + timeDel + now.month.to_s + timeDel +  now.year.to_s + "--" + now.hour.to_s + timeDel + now.min.to_s + timeDel + now.sec.to_s + ":" + now.usec.to_s

    #the application Context is a squish API function
    ctx = currentApplicationContext()
    used_memory = (Float(ctx.usedMemory) / (2**30)).round(3) # human readable (in Gigabytes)

    #this is the string that will be added to the logFile
    logString = "#{command}#{@seperator}#{screenShot}#{@seperator}#{used_memory}#{@seperator}#{get_total_cpu_percentage}#{@seperator}#{nowString}"

    @testlog.puts(logString)
  end

  def takeElementScreenshot(message, filename, widget)
    image = grabWidget(waitForObject(widget))
    format = "PNG"
    path = "#{@testLogLocation}#{filename}.#{format}"
    image.save(path, format)
    htmlFilePath = "file://#{path}".gsub("\\", "/")
    AppendLog("Test.log(#{message})", "<a href=\"#{htmlFilePath}\">#{filename}.#{format}</a>")
  end

  def takeScreenshot
    image = grabWidget(waitForObject(":_MainWindow"))
    format = "PNG"
    filename = "MainWindow_#{@@screenshotCount}.#{format}"
    path = "#{@testLogLocation}#{filename}"
    image.save(path, format)

    @@screenshotCount = @@screenshotCount + 1

    return filename
  end

  def Trace(text)
    Test.log(text) if LOG_TRACE
  end

  def TestLog(text)
    Test.log(text)
    AppendLog("Test.log(#{text})")
  end

  def TestVerify(condition, text)
    verificationText = ""
    filename = nil

    # check to see if the verification failed, if it did, take a screenshot
    if not Test.verify(condition, text)
      screenshot = takeScreenshot
      AppendLog("Test.verify FAILED: #{text}", screenshot)
    else
      AppendLog("Test.verify PASSED: #{text}")
    end

  end

  def TestFail(text)
    screenshot = takeScreenshot
	  Test.fail(text)
	  AppendLog("Test.fail(#{text})", screenshot)
  end

  def TestFatal(text)
    screenshot = takeScreenshot
    Test.fatal(text)
    AppendLog("Test.fatal(#{text})", screenshot)
  end

  def CompleteLog
    # shutdown the text file handle
    @testlog.close

    begin
      HTML_LogGenerator.generate(@testName, @testLogLocation, @fileName)
    rescue Exception => e
      TestFail("Failed to generate HTML log file: #{e.message}")
    end
  end

  ##################### PRIVATE FUNCTIONALITY ########################
  private

  def TestInfo
    ctx = currentApplicationContext()
    nl = "\n"
    @testInfo = ctx.commandLine + nl + ctx.usedMemory.to_s
    return @testInfo
  end

  def getTestName
      _testPath = Squishinfo.testCase
      _testArr = _testPath.split("\\")
      _testIndex = (_testArr.length - 1)
      return _testArr[_testIndex]

  end

  # Returns the total CPU percentage of the windows system as a string
  def get_total_cpu_percentage
    result = execute_wmic("wmic cpu get loadpercentage")

    # in the end, the result array should resemble ["CPUBlahBlahBlah", "XXX"] where XXX is the CPU %
    return result[1]
  end


end
