#encoding: utf-8
require 'hpricot'
require 'httpclient'
require 'uri'
require 'json'
require 'roo'
require 'active_record'
require 'digest/md5'


ActiveRecord::Base.establish_connection(
    :adapter => "mysql",
    :host => "localhost",
    :database => "hotel",
    :username => "root",
    :password => "rootroot",
    :encoding => "utf8")

def get_number(link)#城市对应数字
   @client = HTTPClient.new
      # link = "http://review.qunar.com/tag_beijing_city_#{URI.encode(keyword)}_1.html"
      begin
        doc = Hpricot(@client.get(link).body.encode("utf-8"))
        re_hash = {}
        hotel_city = (doc/".item"/".pr"/:a)[0]["href"].split('/')[4]
        hotel_number = (doc/".item"/".pr"/:a)[0]["href"].split('/')[5].gsub(/dt-/,'')
        re_hash["hotel_city"] = hotel_city
        re_hash["hotel_number"] = hotel_number
      rescue Exception => e      
      end      
       return re_hash
end

def get_link(hotel_name)
  if hotel_name.include?("北京")
    link = "http://review.qunar.com/tag_beijing_city_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("长沙")
    link = "http://review.qunar.com/tag_changsha_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("常州")
    link = "http://review.qunar.com/tag_changzhou_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("福州")
    link = "http://review.qunar.com/tag_fuzhou_fujian_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("成都")
    link = "http://review.qunar.com/tag_chengdu_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("哈尔滨")
    link = "http://review.qunar.com/tag_haerbin_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("呼和浩特")
    link = "http://review.qunar.com/tag_huhehaote_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("上海")
    link = "http://review.qunar.com/tag_shanghai_city_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("锦州")
    link = "http://review.qunar.com/tag_jinzhou_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("昆仑")
    link = "http://review.qunar.com/tag_beijing_city_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("昆山托尼洛")
    link = "http://review.qunar.com/tag_suzhou_jiangsu_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("廊坊")
    link = "http://review.qunar.com/tag_langfang_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("临港")
    link = "http://review.qunar.com/tag_shanghai_city_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("宁波")
    link = "http://review.qunar.com/tag_ningbo_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("璞麗酒店")
    link = "http://review.qunar.com/tag_shanghai_city_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("浦东")
    link = "http://review.qunar.com/tag_shanghai_city_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("曲阜香格里拉")
    link = "http://review.qunar.com/tag_jining_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("深圳")
    link = "http://review.qunar.com/tag_shenzhen_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("沈阳")
    link = "http://review.qunar.com/tag_shenyang_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("苏州")
    link = "http://review.qunar.com/tag_suzhou_jiangsu_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("天津")
    link = "http://review.qunar.com/tag_tianjin_city_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("无锡")
    link = "http://review.qunar.com/tag_wuxi_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("武汉")
    link = "http://review.qunar.com/tag_wuhan_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("西安")
    link = "http://review.qunar.com/tag_xian_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("扬州")
    link = "http://review.qunar.com/tag_yangzhou_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("悦来酒店")
    link = "http://review.qunar.com/tag_wuhan_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("郑州")
    link = "http://review.qunar.com/tag_zhengzhou_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("中国大饭店")
    link = "http://review.qunar.com/tag_beijing_city_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("澳门")
    link = "http://review.qunar.com/tag_macao_city_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("东莞")
    link = "http://review.qunar.com/tag_dongguan_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("海口")
    link = "http://review.qunar.com/tag_haikou_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("杭州")
    link = "http://review.qunar.com/tag_hangzhou_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("惠州")
    link = "http://review.qunar.com/tag_huizhou_guangdong_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("三亚")
    link = "http://review.qunar.com/tag_sanya_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("九华山")
    link = "http://review.qunar.com/tag_jiuhuashan_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("九寨")
    link = "http://review.qunar.com/tag_jiuzhaigou_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("拉萨")
    link = "http://review.qunar.com/tag_lasa_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("丽江")
    link = "http://review.qunar.com/tag_lijiang_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("千岛湖")
    link = "http://review.qunar.com/tag_qiandaohu_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("大连")
    link = "http://review.qunar.com/tag_dalian_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("大连")
    link = "http://review.qunar.com/tag_dalian_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("广西德天漫心度假酒店")
    link = "http://review.qunar.com/tag_chongzuo_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("南昌")
    link = "http://review.qunar.com/tag_nanchang_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("南京")
    link = "http://review.qunar.com/tag_nanjing_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("湛江")
    link = "http://review.qunar.com/tag_zhanjiang_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("浙江安吉JW万豪酒店")
    link = "http://review.qunar.com/tag_huzhou_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("珠海")
    link = "http://review.qunar.com/tag_zhuhai_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("宝御酒店")
    link = "http://review.qunar.com/tag_shanghai_city_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("广州")
    link = "http://review.qunar.com/tag_guangzhou_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("株洲")
    link = "http://review.qunar.com/tag_zhuzhou_#{URI.encode(hotel_name)}_1.html"
  elsif hotel_name.include?("黄山")
    link = "http://review.qunar.com/tag_huangshan_#{URI.encode(hotel_name)}_1.html"
  end
end


def get_comment_link(link,number)
  result = get_number(link)
  puts result
  comment_link = "http://review.qunar.com/api/h/#{result["hotel_city"]}_#{result["hotel_number"]}/detail/rank/v1/page/#{number}"
  puts comment_link
  return comment_link
end

def get_page_number(link,number)
  @client = HTTPClient.new
  comment_link = get_comment_link(link,number)
  doc = Hpricot(@client.get(comment_link).body.encode("utf-8"))
  res = JSON.parse(doc.to_s)
  count = res["data"]["count"]
  if count%10==0
    pag_number = count/10
  else
    pag_number = count/10+1
  end
  puts pag_number
  return pag_number
end

def pass(x)
  x.gsub( /[\u{1F300}-\u{1F64F}\u{1F680}-\u{1F6FF}\u{1F1E6}-\u{1F1FF}
                                                                      \u231A\u231B\u23E9-\u23EC\u23F0\u23F3
                                                                      \u2614\u2615\u2648-\u2653\u267F\u2693\u26A1\u26AA\u26AB\u26B3-\u26BD\u26BF-\u26E1\u26E3-\u26FF
                                                                      \u2705\u270A\u270B\u2728\u274C\u274E\u2753\u2757\u2795\u2796\u2797\u27B0\u27BF
                                                                      \u{1F1E6}-\u{1F1FF}]/x, '')
end

# link = get_link("武汉香格里拉大酒店")
# get_number(link)
# number = get_page_number(link,1)
# for i in 1..number
#   get_comment_link(link,number)
# end

class Hotel< ActiveRecord::Base
  has_many :hotel_comments 
end

class HotelComment< ActiveRecord::Base
  belongs_to :hotel

  @hotels = []
  for hotel_id in 9..106
    @hotels << Hotel.where(id: hotel_id).first
  end

  @hotels.each do |hotel|
    puts hotel_name = hotel.name.force_encoding("utf-8")
    puts hotel_id = hotel.id
    link = get_link(hotel_name)
    puts pag_number = get_page_number(link,1)
    
    @client = HTTPClient.new

    for i in 1..pag_number
      begin
        puts comment_link = get_comment_link(link,i)
        doc = Hpricot(@client.get(comment_link).body.encode("utf-8"))
        res = JSON.parse(doc.to_s)
        list = res["data"]["list"]
        list.each do |list|     
          content = JSON.parse(list["content"])
          # puts content["title"]
          puts list["nickName"]
         # commen_id = Digest::MD5.hexdigest(list["nickName"]+"hotel.qunar.com"+pass(content["feedContent"].to_s))
         # if HotelComment.where(commen_id: commen_id).first.blank?
            HotelComment.create(
                                                      :hotel_id=>hotel_id,
                                                      :hotel_name=>hotel_name,
                                                      :comment_id =>  Digest::MD5.hexdigest(list["nickName"]+"hotel.qunar.com"),
                                                      :title=>content["title"],
                                                      :desp=>pass(content["feedContent"].to_s),
                                                      :travel_type=>content["tripType"],
                                                      :created_time=>Time.parse(content["checkInDate"].gsub(/年/,'').gsub(/月/,'')+"01").strftime('%Y-%m-%d %H:%M:%S'),
                                                      :score=>content["evaluation"],
                                                      :score_clean=>content["subScores"][0]["score"],
                                                      :score_infrastructure=> content["subScores"][2]["score"],
                                                      :score_service=>content["subScores"][3]["score"],
                                                      :score_location=>content["subScores"][4]["score"],
                                                      :score_cost_performance=>content["subScores"][5]["score"],
                                                      :site=>"hotel.qunar.com",
                                                      :user_id=>list["uid"],
                                                      :user_name=>list["nickName"]
                                                      )
        end
      # end
      rescue Exception => e
      end
    end
  end
end





# link =  get_link('北京','北京国贸大酒店') 
# get_page_number(link)

# link1 = get_link('沈阳','沈阳香格里拉大酒店')
# get_page_number(link1)
# link1 = get_link('沈阳香格里拉大酒店')
# get_data(link1)


# http://review.qunar.com/api/h/beijing_city_12482/detail/rank/v1/page/1?
# http://review.qunar.com/api/h/beijing_city_12482/detail/rank/v1/page/1
# http://review.qunar.com/api/h/haerbin_5069/detail/rank/v1/page/1