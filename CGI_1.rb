require 'cgi'
cgi = CGI.new
puts cgi.header
cgi.keys
