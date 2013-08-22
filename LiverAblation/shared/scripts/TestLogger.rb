

class TestLogger
  def initialize(testName)
    @testLogLocation = "C:\\Users\\SethUrban\\Documents\\SquishTestLogs\\"
    @testName = testName
    @fileType = ".txt"
    @fileName = ""
    
    setInitialLogFile()
  end
  
  def setInitialLogFile
    @Header = "TEST COMMAND\t\tSCREENSHOT\t\tTIME\n-------------------------------------------------------"
    
    now = Time.new
    @testLogLocation += @testName + now.strftime("%I_%M_%S") + "\\"
    @testName += now.strftime("%I_%M_%S")
    Dir.mkdir(@testLogLocation)
    #after the testName has been identified above build the full filepath string again in case testName was changed
    @fileName = @testLogLocation + @testName + @fileType
     
    #write the file
    @testlog = File.open(@fileName, "w") 
    @testlog.puts(@Header)
    @testlog.close
  end
  
  def AppendLog(command, screenShot = "ns")
    now = Time.new
    #builds a string out of dates for logging
    timeDel = "."    
    nowString = now.day.to_s + timeDel + now.month.to_s + timeDel +  now.year.to_s + " " + now.hour.to_s + timeDel + now.min.to_s + timeDel + now.sec.to_s + ":" + now.usec.to_s
    
    #this is the string that will be added to the logFile
    tab = "::"
    commWrapper = "<"
    logString = command + tab + screenShot + tab + nowString
     
    
    @testlog = File.open(@fileName, "a")
    @testlog.puts(logString)
    @testlog.close
  end
  
end