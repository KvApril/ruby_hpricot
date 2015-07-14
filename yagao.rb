require 'hpricot'
require 'httpclient'

def pass(html)
  html.to_s.gsub(/<(\S*?)[^>]*>.*?|<.*? \/>/,"").strip
end

@client = HTTPClient.new
link ="http://hotels.ctrip.com/international/996320.html"
doc = Hpricot(@client.get(link).body)

pos = (doc/"#htlDes") 

pos1= (doc/".comment_block"/".user_info")
pos2 = (doc/".comment_block"/".score_pop")
pos3 = (doc/".comment_block"/".comment_txt")
pos4 = (doc/".comment_block"/".useful"/".n")
puts pass(pos)
puts "-"*160
puts pass(pos1)
puts "-"*160
puts pass(pos2)
puts "-"*160
puts pass(pos3)
puts "-"*160
puts pass(pos4)