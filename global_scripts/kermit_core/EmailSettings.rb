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
