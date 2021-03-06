
#http://index.sci99.com/channel/chem/default.aspx?all=true&indid=#{keys[k]}&type=2&Page=#{j}#a_tooltip
#获取上面链接页面的数据,并保存到.csv文件中
require  'hpricot'
require 'httpclient'

#去除html标签
def pass(html)
    html.to_s.gsub(/<(\S*?)[^>]*>.*?|<.*? \/>/,"").strip
end

#将数据保存到文件中
def save_data(data,path)
  File.open(path,"a") do |file|
    file.puts(data.join(","))
    file.close
  end
end

#建立httpclient
@client = HTTPClient.new

#新建一个hash,将各个页码与其所代表的类型一一对应
list = Hash.new
list = { "878"=>"有机化工","847"=>"烯烃","845"=>"乙烯","846"=>"丙烯",
           "850"=>"芳烃","714"=>"纯苯","717"=>"甲苯","848"=>"二甲苯","801"=>"苯乙烯","849"=>"邻苯",
           "853"=>"醇类","851"=>"乙醇","711"=>"乙二醇","852"=>"二乙二醇","719"=>"辛醇",
           "857"=>"酚酮","854"=>"苯酚","855"=>"丙酮","856"=>"丁酮",
           "860"=>"增塑剂","858"=>"DOP","859"=>"苯酐","849"=>"邻二甲苯",
           "876"=>"甲醇及下游价格","693"=>"甲醇","861"=>"甲醛","893"=>"二甲醚","899"=>"MTBE",
           "865"=>"酸酯","862"=>"醋酸","863"=>"醋酸乙烯","864"=>"丙烯酸丁酯",
           "877"=>"化纤原料","710"=>"PTA","888"=>"己内酰胺","886"=>"丙烯腈",
           "870"=>"中间体价格","785"=>"环氧丙烷","866"=>"苯胺","867"=>"顺酐","868"=>"二氯甲烷","869"=>"双酚A",
           "872"=>"涂料原料","871"=>"钛白粉",
           "979"=>"无机化工","873"=>"硫酸","874"=>"盐酸","838"=>"纯碱","739"=>"液碱","875"=>"硝酸"
        }
#hash的key和value值
    keys = list.keys
    values = list.values

#循环进行各个页面的数据抓取
    for k in 0..keys.length
        for j in 1..25
            link = "http://index.sci99.com/channel/chem/default.aspx?all=true&indid=#{keys[k]}&type=2&Page=#{j}#a_tooltip"
            doc = Hpricot(@client.get(link).body)
            pos = (doc/:table/:tr/:td) #定位数据所在的位置,返回的是个数组

            tr_nums = 5
            circle = pos.size / tr_nums
            for i in 1..circle-1
						#将数据存放在数组中
            data = Array[ 
                pass(pos[5*i+0]),
                pass(pos[5*i+1]),
                pass(pos[5*i+2]),
                pass(pos[5*i+3])]

                save_data(data,"化工类/#{values[k]}.csv")
            end
        end
    end
