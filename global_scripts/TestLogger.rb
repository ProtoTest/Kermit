class TestLogger
  attr_reader :testLogLocation
  attr_reader :fileName
  attr_reader :testName

  def initialize
    @testLogLocation = "C:\\Users\\SethUrban\\Documents\\SquishTestLogs\\"
    @testName = getTestName()
    @fileType = ".txt"
    @fileName = ""
    @seperator = ":**:"
    @testInfo = ""

    setInitialLogFile()
    @@htmlHeader = "<html><body><h1>Test Log File</h1><br><h2>" + @testName +"</h2><br>"
    @@htmlFooter = "</body></html>"
    @@htmlPage = ""
  end

  def setInitialLogFile
    now = Time.new
    @testLogLocation += @testName + "_" + now.strftime("%I_%M_%S") + "\\"
    @testName += now.strftime("%I_%M_%S")
    Dir.mkdir(@testLogLocation)
    #after the testName has been identified above build the full filepath string again in case testName was changed
    @fileName = @testLogLocation + @testName + @fileType

    #write the file
    #@testInfo = TestInfo() #this will only work from within squish
    @Header = "TEST COMMAND\t\tSCREENSHOT\t\tMEMORY\t\tTIME\n-------------------------------------------------------"
    @testlog = File.open(@fileName, "w")
    #@testlog.puts(@testInfo)
    @testlog.puts(@Header)
    @testlog.close
  end

  def AppendLog(command, screenShot = "ns")
    
    now = Time.new
    #builds a string out of dates for logging
    timeDel = "."
    nowString = now.day.to_s + timeDel + now.month.to_s + timeDel +  now.year.to_s + " " + now.hour.to_s + timeDel + now.min.to_s + timeDel + now.sec.to_s + ":" + now.usec.to_s

    #the application Context is a squish API function
    ctx = currentApplicationContext()
    #this is the string that will be added to the logFile
    logString = command + @seperator + screenShot + @seperator + ctx.usedMemory.to_s + @seperator + nowString


    @testlog = File.open(@fileName, "a")  #the 'a' opens the file in append mode, placing the cursor at the end of the file
    @testlog.puts(logString)
    @testlog.close
  end

  def CompleteLog
    #This is going to read the text log for logs and screenshots and compile them into an HTML logfile
    #setup the fancy stuff
    setupTable()
    _tableRowOpen = "<tr>"
    _tableRowClose = "</tr>"
    _tableRow = ""
    #open the existing logfile and read each line into an array --remembering to skip the first two lines
    _logLines = IO.readlines(@fileName) #should do a catch here perhaps

    _limit = _logLines.length - 1
    for counter in 0.._limit
      if counter > 1 #this will ignore the first two lines
        _items = _logLines[counter].split(@seperator)
        _itemLimit = _items.length - 1
        for count in 0.._itemLimit
          _tableRow += "<td>" + _items[count] + "</td>"
        end
        _tableRow = _tableRowOpen + _tableRow + _tableRowClose
        @@htmlPage += _tableRow
        _tableRow = ""
      end
    end


    #now write the thing to disk
    _htmlPage = @@htmlHeader + @@htmlPage + @@htmlFooter
    @testlog = File.open(@testLogLocation + @testName + ".html", "w")
    @testlog.puts(_htmlPage)
    @testlog.close

  end

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
    _tableHead = "<tr><th>TestCommand</th><th>ScreenShot</th><th>Memory</th><th>Time</th></tr>"

    @@htmlPage = _tableScript + _tableCSS + _tableTag + _tableHead

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



end
