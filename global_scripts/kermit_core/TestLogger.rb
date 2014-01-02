# encoding: UTF-8
require 'squish'

include Squish

require findFile("scripts", "kermit_core\\Common.rb")
require findFile("scripts", "kermit_core\\Env.rb")

########################################################################################
#
#  Test Logger
#     Used to certify the actions of a particular test as it happens and build HTML output log incorporating screenshots
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
    @@htmlHeader = "<html><body><h1>Test Log File</h1><br><h2>" + @testName +"</h2><br>"
    @@htmlFooter = "</body></html>"
    @@executionEnvHTML = "<style type=\"text/css\">
    #execution {font-family: verdana,sans-serif;
    font-size: 12px;
    letter-spacing: 0pt;
    line-height: 1.5;}

    </style>" + "<div id='execution'>
    <div>Execution Environment:</div>
    <div>Hardware: </br>
    #{Env.system_manufacturer} #{Env.system_model} #{Env.system_type} </br>
    #{Env.cpu_name} </br>
    Total Memory: #{Env.mem_total_physical} </br>
    Total HDD size: #{Env.disk_size_total} </br>
    HDD space available: #{Env.disk_size_avail} </br>
    </br></div>
    <div>
    Software: </br>
    Operating System: #{Env.os_info} - #{Env.os_serial} </br>
    Squish Version: #{Env.squish_version} </br></br></br></div>

    </div>"

    @@htmlPage = ""
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
    #@testlog.puts(@testInfo)
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

    #This is going to read the text log for logs and screenshots and compile them into an HTML logfile
    #setup the fancy stuff
    setupTable()
    _tableRow = ""
    #open the existing logfile and read each line into an array --remembering to skip the first two lines
    _logLines = IO.readlines(@fileName) #should do a catch here perhaps

    _limit = _logLines.length - 1
    for counter in 0.._limit
      if counter > 1 #this will ignore the first two lines
        _items = _logLines[counter].split(@seperator)
        _itemLimit = _items.length - 1
        for count in 0.._itemLimit
          # check to see if the item is an actual screenshot filename, if it is, wrap it in anchor tags
          data = _items[count]
          data = "<a href='file:///#{@testLogLocation}#{data}'>#{data}</a>" if (count == 1) and !data.eql?('ns')

          _tableRow += "<td>#{data}</td>"
        end
        _tableRow = "<tr>#{_tableRow}</tr>"
        @@htmlPage += _tableRow
        _tableRow = ""
      end
    end

    # complete the div for the table
    @@htmlPage += "</div>"


    #now write the thing to disk
    _htmlPage = @@htmlHeader + @@executionEnvHTML + @@htmlPage + @@htmlFooter
    @testlog = File.open(@testLogLocation + @testName + ".html", "w")
    @testlog.puts(_htmlPage)
    @testlog.close

  end

  ##################### PRIVATE FUNCTIONALITY ########################
  private

  # insert some nice row highlight javascript and initialize the result table
  def setupTable
    _tableScript = "<script type=\"text/javascript\">
  window.onload=function(){
  var tfrow = document.getElementById('tfhover').rows.length;
  var tbRow=[];
  for (var i=1;i<tfrow;i++) {
    tbRow[i]=document.getElementById('tfhover').rows[i];
    tbRow[i].onmouseover = function(){
      this.style.backgroundColor = '#ffffff';
    };
    tbRow[i].onmouseout = function() {
      this.style.backgroundColor = '#d4e3e5';
    };
  }
};
</script>"

    _tableCSS = "<style type=\"text/css\">
      table.tftable {font-size:12px;color:#333333;width:100%;border-width: 1px;border-color: #729ea5;border-collapse: collapse;}
      table.tftable th {font-size:12px;background-color:#acc8cc;border-width: 1px;padding: 8px;border-style: solid;border-color: #729ea5;text-align:left;}
      table.tftable tr {background-color:#d4e3e5;}
      table.tftable td {font-size:12px;border-width: 1px;padding: 8px;border-style: solid;border-color: #729ea5;}
      </style>"
    _tableTag = "<table id=\"tfhover\" class=\"tftable\" border=\"1\">"
    _tableHead = "<tr><th>TestCommand</th><th>ScreenShot</th><th>Used Memory (GB)</th><th>Total CPU %</th><th>Time</th></tr>"

    @@htmlPage = _tableScript + _tableCSS + "<div>" + _tableTag + _tableHead

  end

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
