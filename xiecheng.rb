require 'active_record'
require 'uri'
require 'hpricot'
require 'httpclient'
require 'json'
require 'digest/md5'

ActiveRecord::Base.establish_connection(
    :adapter => "mysql2",
    :host => "rds0i96b9l2h7p94x5od.mysql.rds.aliyuncs.com",
    :database => "hotel",
    :username => "hotel",
    :password => "hotel123",
    :encoding => "utf8")

class Hotel < ActiveRecord::Base
end

class HotelComment < ActiveRecord::Base
  # http://hotels.ctrip.com/hotel/beijing1/k1
  def self.get_search_link(hotel_name)
    if hotel_name.include?('北京')
      'http://hotels.ctrip.com/hotel/beijing1/k1'
    elsif hotel_name.include?('上海')
      'http://hotels.ctrip.com/hotel/shanghai2/k1'
    elsif hotel_name.include?('成都')
      'http://hotels.ctrip.com/hotel/chengdu28/k1'	
    elsif hotel_name.include?('长沙')
   	  'http://hotels.ctrip.com/hotel/changsha206/k1'
    elsif hotel_name.include?('常州')
      'http://hotels.ctrip.com/hotel/changzhou213/k1'
    elsif hotel_name.include?('福州')
      'http://hotels.ctrip.com/hotel/fuzhou258/k1'
    elsif hotel_name.include?('深圳')
      'http://hotels.ctrip.com/hotel/shenzhen30/k1'
    elsif hotel_name.include?('沈阳')
      'http://hotels.ctrip.com/hotel/shenyang451/k1'	
    elsif hotel_name.include?('苏州')
      'http://hotels.ctrip.com/hotel/suzhou14/k1'
    elsif hotel_name.include?('天津')
      'http://hotels.ctrip.com/hotel/tianjin3/k1'	
    elsif hotel_name.include?('无锡')
      'http://hotels.ctrip.com/hotel/wuxi13/k1'
    elsif hotel_name.include?('武汉')
      'http://hotels.ctrip.com/hotel/wuhan477/k1'
    elsif hotel_name.include?('西安')
      "http://hotels.ctrip.com/hotel/xi'an10/k1"
    elsif hotel_name.include?('郑州')
      'http://hotels.ctrip.com/hotel/zhengzhou559/k1'
    elsif hotel_name.include?('澳门')
      'http://hotels.ctrip.com/hotel/macau59/k1'
    elsif hotel_name.include?('三亚')
      'http://hotels.ctrip.com/hotel/sanya43/k1'
    elsif hotel_name.include?('宁波')
      'http://hotels.ctrip.com/hotel/ningbo375/k1'
    elsif hotel_name.include?('丽江')
      'http://hotels.ctrip.com/hotel/lijiang37/k1'
    elsif hotel_name.include?('杭州')
      'http://hotels.ctrip.com/hotel/hangzhou17/k1'
    elsif hotel_name.include?('大连')
      'http://hotels.ctrip.com/hotel/dalian6/k1'
    elsif hotel_name.include?('南昌')
      'http://hotels.ctrip.com/hotel/nanchang376/k1'
    elsif hotel_name.include?('株洲')
      'http://hotels.ctrip.com/hotel/zhuzhou601/k1'
    elsif hotel_name.include?('黄山')
      'http://hotels.ctrip.com/hotel/huangshan23/k1'
    elsif hotel_name.include?('九寨')
      'http://hotels.ctrip.com/hotel/jiuzhaigou91/k1'
    elsif hotel_name.include?('东莞')
      'http://hotels.ctrip.com/hotel/dongguan223/k1'	
    elsif hotel_name.include?('呼和浩特')
      'http://hotels.ctrip.com/hotel/hohhot103/k1'
    elsif hotel_name.include?('廊坊')
      'http://hotels.ctrip.com/hotel/langfang340/k1'
    elsif hotel_name.include?('临港')
      'http://hotels.ctrip.com/hotel/shanghai2/k1'
    elsif hotel_name.include?('广州')
      'http://hotels.ctrip.com/hotel/guangzhou32/k1'
    else
    	''
    end
  end
  
  # http://hotels.ctrip.com/hotel/369675.html
  def self.get_hotel_web_id(search_link)
  	@client = HTTPClient.new
    search_text = @client.get(search_link).body
    ec = Encoding::Converter.new("GBK", "utf-8")
    hotel_doc = Hpricot(ec.convert(search_text))
    return (hotel_doc/".searchresult_info_name"/".searchresult_name")[0]["data-id"]
  end

  def self.get_page_number(search_link)
    @client = HTTPClient.new
    search_text = @client.get(search_link).body
    ec = Encoding::Converter.new("GBK", "utf-8")
    hotel_doc = Hpricot(ec.convert(search_text))
    return (hotel_doc/".c_page_box"/"#cTotalPageNum")[0]["value"]
  end

end

def pure(html)
  html.to_s.gsub(/<(\S*?)[^>]*>.*?|<.*? \/>/,"")
end



class HotelComment < ActiveRecord::Base
  @hotels = []
  for hotel_id in 9..106
    @hotels << Hotel.where(id: hotel_id).first
  end
  @hotels.each do |hotel|
    begin
      hotel_id = hotel.id
      hotel_name = hotel.name
      search_link = HotelComment.get_search_link(hotel_name) + URI.encode(hotel_name)  
      puts hotel_web_id = HotelComment.get_hotel_web_id(search_link)
      puts comment_link = "http://hotels.ctrip.com/hotel/dianping/" + hotel_web_id + "_p1t0.html"
      puts page_number = HotelComment.get_page_number(comment_link).to_i
      # page_number = 10
    rescue Exception => e
    end
    
    for page_index in 1..page_number
      begin
      comment_link = "http://hotels.ctrip.com/hotel/dianping/" + hotel_web_id + "_p#{page_index}t0.html"
      @client = HTTPClient.new
      text = @client.get(comment_link).body
      ec = Encoding::Converter.new("GBK", "utf-8")
      comment_doc = Hpricot(ec.convert(text))
      (comment_doc/".comment_block").each do |comment|
        puts room = pure(comment/".room")
        HotelComment.create(
          hotel_id: hotel_id,
          hotel_name: hotel_name,
          comment_id: Digest::MD5.hexdigest(comment["data-cid"] + (comment/".name"/:span)[0][:alt] + Time.now.to_s + "hotels.ctrip.com"),
          desp: pure(comment/".comment_txt"/:p/".J_commentDetail"),
          site: "hotels.ctrip.com",
          created_on: room[0..3]+"-"+room[5..6]+"-01"+" 23:15:30 UTC",
          created_time: Time.now
        )
      end
      rescue Exception => e
      end
    end
  end
end
