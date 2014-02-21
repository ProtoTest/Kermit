require 'fileutils'
require File.join(File.dirname(__FILE__), "Env.rb")

class HTML_LogGenerator

  def self.generate(test_name, log_path, infile)
    graphLibDir = File.join(File.dirname(__FILE__), "reports")
    outputFile = log_path + test_name + ".html"

    @@seperator = ":**:"

    @@htmlHeader = "<!DOCTYPE html><meta charset=\"utf-8\"><body><h1>Test Log File</h1><br><h2>" + test_name +"</h2><br>
                        <script src=\"d3.v3.js\"></script>
                        <script src=\"jquery-1.10.2.js\"></script>
                        <script src=\"underscore.js\"></script>
                        <script src=\"visuals.js\"></script>
                        <link rel=\"stylesheet\" type=\"text/css\" href=\"visuals.css\" media=\"screen\" />"
    @@htmlFooter = "</body>"
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

    setupTable

    _tableRow = ""
    #open the existing logfile and read each line into an array --remembering to skip the first two lines
    begin
      _logLines = IO.readlines(infile)
    rescue Exception => e
      raise "Failed to read from file #{infile}: #{e.message}"
    end

    _limit = _logLines.length - 1
    for counter in 0.._limit
      if counter > 1 #this will ignore the first two lines
        _items = _logLines[counter].split(@@seperator)
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

    #
    # Write HTML log and javascript graph libraries to disk
    #
    begin
      write_html_do_disk(outputFile)
    rescue Exception => e
      raise "Failed to write #{outputFile} HTML to disk: #{e.message}"
    end

    # copy the graph javascript libraries to output dir
    begin
      FileUtils.cp_r("#{graphLibDir}\\.", log_path)
    rescue Exception => e
      raise "Failed to copy 3rd party graph libraries to #{log_path}: #{e.message}"
    end
  end


  ##################### PRIVATE FUNCTIONALITY ########################
  private

  def self.write_html_do_disk(filename)
    #now write the thing to disk
    _htmlPage = @@htmlHeader + @@executionEnvHTML + @@htmlPage + @@htmlFooter
   html_file = File.open(filename, "w")
   html_file.puts(_htmlPage)
   html_file.close
  end

  # insert some nice row highlight javascript and initialize the result table
  def self.setupTable
    _tableCSS = "<style type=\"text/css\">
    table.tftable {font-size:12px;color:#333333;width:100%;border-width: 1px;border-color: #729ea5;border-collapse: collapse;}
    table.tftable th {font-size:12px;background-color:#acc8cc;border-width: 1px;padding: 8px;border-style: solid;border-color: #729ea5;text-align:left;}
    table.tftable tr {background-color:#d4e3e5;}
    table.tftable td {font-size:12px;border-width: 1px;padding: 8px;border-style: solid;border-color: #729ea5;}
    </style>"
    _tableTag = "<div id=\"chartarea\"></div><div id=\"chartarea2\"></div><table id=\"tfhover\" class=\"tftable\" border=\"1\">"
    _tableHead = "<tr><th>TestCommand</th><th>ScreenShot</th><th>Used Memory (GB)</th><th>Total CPU %</th><th>Time</th></tr>"
    @@htmlPage = _tableCSS + "<div>" + _tableTag + _tableHead
  end
end