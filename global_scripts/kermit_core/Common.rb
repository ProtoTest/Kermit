# encoding: UTF-8
require 'squish'

include Squish

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
  # change directories to the location of the send_email.rb script
  Dir.chdir("../../bin")

  sys_cmd = "C:/Ruby200-x64/bin/ruby #{Dir.pwd}/send_email.rb '#{subject}' '#{body}'"
  sys_cmd += " '#{attachment}'" if not attachment.nil?

  @@logFile.Trace("Calling system with #{sys_cmd}")

  if not system(sys_cmd)
    @@logFile.TestFail("Failed to send email with subject: #{subject}")
  end
end