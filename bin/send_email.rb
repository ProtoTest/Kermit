#!/usr/bin/env ruby

require 'net/smtp'

# Squish uses ruby 1.9.1 which DOES NOT support SSL out of the box. Can't use a gmail account
# gmail email server settings - email account to send test complete or other emails, unless you install
# a more commonly used version of ruby that supports it.
USERNAME = "covidian.squish.sender@gmail.com"
PASSWORD = "prototest123!"
DOMAIN = "gmail.com"
SMTP_SERVER_ADDR = "smtp.gmail.com"
SMTP_SERVER_PORT = 587

=begin
# yahoo email server settings. Yahoo will lock out your account if you don't use ssl
USERNAME = "covidian.squish@yahoo.com"
PASSWORD = "Prototest123"
DOMAIN = "yahoo.com"
SMTP_SERVER_ADDR = "smtp.mail.yahoo.com"
SMTP_SERVER_PORT = 25
=end

# address to send automation emails to
RECIPIENTS = "msiwiec@prototest.com"

def usage
  "Usage: #{$PROGRAM_NAME} <subject> <body> <attachment (optional)>"
end

# CLO?
if ARGV.length < 2 or ARGV.length > 3
  abort usage
else
  SUBJECT = ARGV[0]
  BODY = ARGV[1]
  ATTACHMENT = ARGV[2]
end

msg_attachment = ""

marker = (0...50).map{ ('a'..'z').to_a[rand(26)] }.join

if not ATTACHMENT.nil?
  begin
    filecontent = File.read(ATTACHMENT)
    encodedcontent = [filecontent].pack("m")   # base64

          # Define the attachment section
    msg_attachment = <<EOF
Content-Type: multipart/mixed; name=\"#{File.basename(ATTACHMENT)}\"
Content-Transfer-Encoding:base64
Content-Disposition: attachment; filename="#{File.basename(ATTACHMENT)}"

#{encodedcontent}
--#{marker}--
EOF
  rescue Exception => e
    raise "Could not read file #{ATTACHMENT}: #{e.message}"
  end
end

msg_hdr = <<EOF
From: #{USERNAME}
To: #{RECIPIENTS}
Subject: #{SUBJECT}
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary=#{marker}
--#{marker}
EOF

# Define the message action
msg_action = <<EOF
Content-Type: text/plain
Content-Transfer-Encoding:8bit

#{BODY}
--#{marker}
EOF

mailtext = "#{msg_hdr} #{msg_action}"
mailtext += "#{msg_attachment}" if not ATTACHMENT.nil?

begin
  smtp = Net::SMTP.new(SMTP_SERVER_ADDR, SMTP_SERVER_PORT)
  smtp.enable_starttls ## squish uses ruby version 1.9.1 which does not support openssl
  smtp.start(DOMAIN, USERNAME, PASSWORD, :login) do |smtp|
    smtp.send_message(mailtext, USERNAME, RECIPIENTS)
    smtp.finish
  end
rescue Exception => e
  abort "#{__method__}(): #{e.message}"
end