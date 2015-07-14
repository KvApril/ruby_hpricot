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
  
  def self.get_search_link(hotel_name)
    if hotel_name.include?('北京')
      'http://hotel.elong.com/search/list_cn_0101.html?keywords='
    elsif hotel_name.include?('上海')
      'http://hotel.elong.com/search/list_cn_0201.html?keywords='
    elsif hotel_name.include?('成都')
      'http://hotel.elong.com/search/list_cn_2301.html?keywords='	
    elsif hotel_name.include?('长沙')
   	  'http://hotel.elong.com/search/list_cn_1901.html?keywords='
    elsif hotel_name.include?('常州')
      'http://hotel.elong.com/search/list_cn_1103.html?keywords='
    elsif hotel_name.include?('福州')
      'http://hotel.elong.com/search/list_cn_1402.html?keywords='
    elsif hotel_name.include?('深圳')
      'http://hotel.elong.com/search/list_cn_2003.html?keywords='
    elsif hotel_name.include?('沈阳')
      'http://hotel.elong.com/search/list_cn_0802.html?keywords='	
    elsif hotel_name.include?('苏州')
      'http://hotel.elong.com/search/list_cn_1102.html?keywords='
    elsif hotel_name.include?('天津')
      'http://hotel.elong.com/search/list_cn_0301.html?keywords='	
    elsif hotel_name.include?('无锡')
      'http://hotel.elong.com/search/list_cn_1105.html?keywords='
    elsif hotel_name.include?('武汉')
      'http://hotel.elong.com/search/list_cn_1801.html?keywords='
    elsif hotel_name.include?('西安')
      'http://hotel.elong.com/search/list_cn_2701.html?keywords='
    elsif hotel_name.include?('郑州')
      'http://hotel.elong.com/search/list_cn_1701.html?keywords='
    elsif hotel_name.include?('澳门')
      'http://hotel.elong.com/search/list_cn_3301.html?keywords='
    elsif hotel_name.include?('三亚')
      'http://hotel.elong.com/search/list_cn_2201.html?keywords='
    elsif hotel_name.include?('宁波')
      'http://hotel.elong.com/search/list_cn_1202.html?keywords='
    elsif hotel_name.include?('丽江')
      'http://hotel.elong.com/search/list_cn_2503.html?keywords='
    elsif hotel_name.include?('杭州')
      'http://hotel.elong.com/search/list_cn_1201.html?keywords='
    elsif hotel_name.include?('大连')
      'http://hotel.elong.com/search/list_cn_0801.html?keywords='
    elsif hotel_name.include?('南昌')
      'http://hotel.elong.com/search/list_cn_1501.html?keywords='
    elsif hotel_name.include?('株洲')
      'http://hotel.elong.com/search/list_cn_1902.html?keywords='
    elsif hotel_name.include?('黄山')
      'http://hotel.elong.com/search/list_cn_1302.html?keywords='
    elsif hotel_name.include?('九寨')
      'http://hotel.elong.com/search/list_cn_2311.html?keywords='
    elsif hotel_name.include?('东莞')
      'http://hotel.elong.com/search/list_cn_2007.html?keywords='	
    elsif hotel_name.include?('呼和浩特')
      'http://hotel.elong.com/search/list_cn_0701.html?keywords='
    elsif hotel_name.include?('廊坊')
      'http://hotel.elong.com/search/list_cn_0511.html?keywords='
    elsif hotel_name.include?('临港')
      'http://hotel.elong.com/search/list_cn_0937.html?keywords='
    elsif hotel_name.include?('广州')
      'http://hotel.elong.com/search/list_cn_2001.html?keywords='
    else
    	''
    end
  end

  def self.get_hotel_id(search_link)
  	@client = HTTPClient.new
    search_doc = Hpricot(@client.get(search_link).body.encode("utf-8"))
    hotel_link = (search_doc/".h_info_b1"/:a)[0][:href] #/beijing/50101545/
    hotel_id = ""
    hotel_link.scan(/\d/).each { |e| hotel_id += e}
    return hotel_id
  end

  # http://hotel.elong.com/ajax/detail/gethotelreviews/?hotelId=50101545&recommendedType=0&pageIndex=1
  def self.get_comment_link(hotel_id)
  	"http://hotel.elong.com/ajax/detail/gethotelreviews/?hotelId=" + hotel_id + "&recommendedType=0&pageIndex="
  end

  def self.get_page_number(comment_link)
  	comment_link += "1"
  	@client = HTTPClient.new
  	json_doc = JSON.parse(@client.get(comment_link).body)
  	return json_doc["totalNumber"]
  end
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
			hotel_id = HotelComment.get_hotel_id(search_link)
			comment_link = HotelComment.get_comment_link(hotel_id)
			puts page_number = HotelComment.get_page_number(comment_link)
			@client = HTTPClient.new
		rescue Exception => e
		end

		for page_index in 1..page_number
			begin
		  puts comment_page_link = comment_link + page_index.to_s
		  comment_page_json = JSON.parse(@client.get(comment_page_link).body)
		  comment_page_json["contents"].each do |comment|
		  	HotelComment.create(
		  	  hotel_id: hotel_id,
		  	  hotel_name: hotel_name,
		  	  comment_id: Digest::MD5.hexdigest(comment["commentId"].to_s + comment["commentUser"]["nickName"] + comment["createTime"].to_s + "hotel.elong.com"),
		  	  # title: ,
		  	  desp: comment["content"],
		  	  # travel_type: ,
		  	  # dsep_pic: ,
		  	  room_type: comment["commentExt"]["order"]["roomTypeName"],
		  	  created_time: comment["createTimeString"],
		  	  # useful_count: ,
		  	  reply_count: comment["replys"].count,
		  	  # is_hot: ,
		  	  # score: ,
		  	  # score_location: ,
		  	  # score_infrastructure: ,
		  	  # score_service: ,
		  	  # score_clean: ,
		  	  # score_food: ,
		  	  # score_cost_performance: ,
		  	  # score_entertainment: ,
		  	  # score_comfortable: ,
		  	  site: "hotel.elong.com",
		  	  created_on: comment["createTimeString"],
		  	  # updated_on: ,
		  	  user_id: comment["commentUser"]["userId"],
		  	  user_name: comment["commentUser"]["nickName"],
		  	  # user_img: ,
		  	  # user_lvl: ,
		  	  # user_city: ,
		  	  # user_footmark_count: ,
		  	  user_comment_count: comment["commentUser"]["commentCount"]
		  	  # user_useful_count: ,
		  	  # user_upload_pic_count: 
		  	)
		  end	
			rescue Exception => e
			end

		end
	end
end






http://hotel.qunar.com/city/beijing_city/
http://hotel.qunar.com/city/beijing_city/q-#{URI.encode('beijing...')}
http://review.qunar.com/api/h/beijing_city_12482/detail/rank/v1/page/1

 # res = {}
        # title = content["title"]
        # res["title"] = title
        # desp = content["feedContent"]
        # res["desp"] = pass(desp.to_s)
        # travel_type = content["tripType"]
        # res["travel_type"] = travel_type
        # created_time = content["checkInDate"].gsub(/年/,'')
        # res["created_time"] = Time.parse(created_time.gsub(/月/,'')+"01").strftime('%Y-%m-%d %H:%M:%S')
        # score = content["evaluation"]
        # res["score"] = score
        # if !content["subScores"].empty?
        #   score_clean = content["subScores"][0]["score"]
        #   res["score_clean"] = score_clean
        #   score_infrastructure = content["subScores"][2]["score"]
        #   res["score_infrastructure"] = score_infrastructure
        #   score_service = content["subScores"][3]["score"]
        #   res["score_service"] = score_service
        #   score_location = content["subScores"][4]["score"]
        #   res["score_location"] = score_location
        #   score_cost_performance = content["subScores"][5]["score"]
        #   res["score_cost_performance"] = score_cost_performance
        # end
        # user_id = list["uid"]
        # res["user_id"] = user_id
        # user_name = list["nickName"]
        # res["user_name"] = user_name
        # puts res

