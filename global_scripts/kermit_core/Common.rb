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
  msg_attachment = ""
  marker = (0...50).map{ ('a'..'z').to_a[rand(26)] }.join

  if not attachment.nil?
    begin
      filecontent = File.read(attachment)
      encodedcontent = [filecontent].pack("m")   # base64

            # Define the attachment section
      msg_attachment = <<EOF
Content-Type: multipart/mixed; name=\"#{File.basename(attachment)}\"
Content-Transfer-Encoding:base64
Content-Disposition: attachment; filename="#{File.basename(attachment)}"

#{encodedcontent}
--#{marker}--
EOF
    rescue Exception => e
      raise "Could not read file #{attachment}: #{e.message}"
    end
  end

  msg_hdr = <<EOF
From: #{USERNAME}
To: #{RECIPIENTS}
Subject: #{subject}
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary=#{marker}
--#{marker}
EOF

  # Define the message action
  msg_action = <<EOF
Content-Type: text/plain
Content-Transfer-Encoding:8bit

#{body}
--#{marker}
EOF

  mailtext = "#{msg_hdr} #{msg_action} #{msg_attachment}"

  begin
    smtp = Net::SMTP.new(SMTP_SERVER_ADDR, SMTP_SERVER_PORT)
    smtp.enable_starttls ## squish uses ruby version 1.9.1 which does not support openssl
    smtp.start(DOMAIN, USERNAME, PASSWORD, :login) do |smtp|
      smtp.send_message(mailtext, USERNAME, RECIPIENTS)
      smtp.finish
    end
  rescue Exception => e
    @@logFile.TestLog("#{__method__}(): #{e.message}")
  end
end