require 'hpricot'
require 'httpclient'

def pass(html)
  html.to_s.gsub(/<(\S*?)[^>]*>.*?|<.*? \/>/,"").strip
end

def save_data(data, path)
  File.open(path, "a+") do |file| 
    file.puts(data.join(",")) 
    file.close
  end 
end

@client = HTTPClient.new
link = "http://index.sci99.com/channel/fert/default.aspx?indid=608&type=2"
doc = Hpricot(@client.get(link).body)
#page = (doc/".manu"/:a)[:Page]
#puts  page

for j in 1..25
    link = "http://index.sci99.com/channel/fert/default.aspx?all=true&indid=608&type=2&Page=#{j}#a_tooltip"
    doc = Hpricot(@client.get(link).body)
    pos = (doc/:table/:tr/:td)
     
    tr_nums = 5
    circle = pos.size / tr_nums
    for i in 1..circle-1
      data = Array[
        pass(pos[5*i+0]),
        pass(pos[5*i+1]),
        pass(pos[5*i+2]),
        pass(pos[5*i+3])]

     save_data(data, "农资类/尿素.csv")
    end
end
