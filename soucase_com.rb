#http://search.soucase.com/search.do?sw=%E6%89%8B%E6%9C%BA&channelid=181&orderID=-1&orderType=&field=0&selectAdv=&swarrayAdv=&fieldAdv=
require 'hpricot'
require 'httpclient'
require 'uri'
require 'active_record'

# ActiveRecord::Base.establish_connection(
#   :adapter => "mysql2",
#   :host => "127.0.0.1",
#   :database => "test",
#   :username => "root",
#   :password => "123456",
#   :encoding => "utf8")

# class CustomerData < ActiveRecord::Base
  
# end


def main
	keyword = "手机"
	@client = HTTPClient.new
	link = "http://search.soucase.com/search.do?sw=#{URI.encode(keyword)}&channelid=181&orderID=-1&orderType=&field=0&selectAdv=&swarrayAdv=&fieldAdv="
	doc = Hpricot(@client.get(link).body)
	for i in 0..9
		puts meta = doc.search("input[@id=metaid_#{i}]")[0][:value]
		puts channel = doc.search("input[@id=channelid_#{i}]")[0][:value]
		puts inventtitle = doc.search("input[@id=inventtitle_#{i}]")[0][:value].to_s.gsub(/<(\S*?)[^>]*>.*?|<.*? \/>/,"")
		puts "-"*160
	end

end