require 'rubygems'    
require 'hpricot'  
require 'open-uri'  
require 'httpclient'

@client = HTTPClient.new
 link = "http://tieba.baidu.com/p/3576130522"
 doc = Hpricot(@client.get(link).body)
 imgs = doc.search("img[@class=BDE_Image]")

for i in 0..imgs.length-100
    s = @client.get(imgs[i][:src])
    File.open("hpricot/img","w+") do |file| 
        file.puts s[i]
    end
end