#模拟post请求,向网站发送数据,获取返回参数
require 'hpricot'
require 'httpclient'
require 'json'

def pass(html)
  html.to_s.gsub(/<(\S*?)[^>]*>.*?|<.*? \/>/,"").strip
end

def send_params(params)
  client = HTTPClient.new
  sqh={'sqh'=>params.to_s}#hash集合
  link = "http://app.sipo-reexam.gov.cn/reexam_out/koushen/searchoralaction.jsp"
  str = client.post(link,sqh)
#puts str.body
  doc = Hpricot(str.body)
  pos = (doc/:table/:a)

  data = Array[
      pass(pos[0]),
      pass(pos[1]),
      pass(pos[2]),
      pass(pos[3])]

  puts data.to_json
end

 send_params(201430009113.9)