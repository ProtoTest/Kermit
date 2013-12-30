# encoding: UTF-8
require 'squish'

include Squish

require findFile("scripts", "kermit_core\\TestConfig.rb")

require 'net/smtp'

# Basic message dialog box with OK button
# Params: title - message box title
#         msg - message to display
def message_dialog(title, msg)
  messageBox = QMessageBox.new
  if qVersion() >= "4.2.0"
    messageBox.setWindowTitle(title)
  end
  messageBox.setText(msg)
  messageBox.addButton(QMessageBox::OK)
  which = messageBox.exec()
  if which == QMessageBox::OK
    # TODO: possibly setup a call back to do something?
  end
end


# sends an email with subject, body, and optional attachment to RECIPIENTS
def send_email(subject, body, attachment=nil)
  if SEND_EMAIL
    # change directories to the location of the send_email.rb script
    Dir.chdir("../../bin")

    sys_cmd = "C:/#{RUBY_VERSION_EXTERNAL}/bin/ruby #{Dir.pwd}/send_email.rb '#{subject}' '#{body}'"
    sys_cmd += " '#{attachment}'" if not attachment.nil?

    @@logFile.Trace("Calling system with #{sys_cmd}")

    if not system(sys_cmd)
      @@logFile.TestFail("Failed to send email with subject: #{subject}")
    end
  else
    @@logFile.Trace("Email functionality is disabled")
  end
end

# call this to finalize the test and build the HTML test log
def completeTest
  @@logFile.CompleteLog()

  # TODO: Get the test name that completed
  send_email("Test Completed", "Test Completed")
end

#
# install crash, hang, etc event handlers
#
def crashHandler
  # perform any necessary cleanup here

  # Log and fail
  @@logFile.TestFatal("Application under test '#{currentApplicationContext().name}' crashed")
  completeTest
end

def timeoutHandler
  # perform any necessary cleanup here

  # Log and fail
  @@logFile.TestFatal("Application under test '#{currentApplicationContext().name}' timed-out")
  completeTest
end

def installEventHandlers
  @@logFile.TestLog("#{__method__}: Registering event handlers")
  installEventHandler("Crash", "crashHandler")
  installEventHandler("Timeout", "timeoutHandler")
end

# Executes the given wmic command and returns the result hash
# Params: command_str - wmic command string
def execute_wmic(command_str)
  pipe = IO.popen(command_str)

  # returns a string of information with a bunch of spaces and newlines
  result = pipe.readlines

  # Close the process pipe
  pipe.close
  pipe = nil

  # Santize all the extra junk returned
  result.delete("\n")
  result.each do |x|
    x.gsub!(/[ \n]/, "")
  end


  # turn this array of key-value string pairs into a hash, if the wmic command
  # is returning the full list of values from the query
  if command_str.include?("list full")
    hash = Hash.new
    result.each_with_index do |x|
      kv_array = x.split('=')
      hash[kv_array[0]] = kv_array[1]
    end

    return hash
  end

  return result
end
