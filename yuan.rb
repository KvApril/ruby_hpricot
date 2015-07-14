require 'roo'
require 'active_record'
require 'hpricot'
require 'httpclient'
require 'uri'
require 'digest/md5'

ActiveRecord::Base.establish_connection(
    :adapter => "mysql2",
    :host => "rds0i96b9l2h7p94x5od.mysql.rds.aliyuncs.com",
    :database => "hotel",
    :username => "hotel",
    :password => "hotel123",
    :encoding => "utf8")

def pass(x)
  x.gsub( /[\u{1F300}-\u{1F64F}\u{1F680}-\u{1F6FF}\u{1F1E6}-\u{1F1FF}
                                                                      \u231A\u231B\u23E9-\u23EC\u23F0\u23F3
                                                                      \u2614\u2615\u2648-\u2653\u267F\u2693\u26A1\u26AA\u26AB\u26B3-\u26BD\u26BF-\u26E1\u26E3-\u26FF
                                                                      \u2705\u270A\u270B\u2728\u274C\u274E\u2753\u2757\u2795\u2796\u2797\u27B0\u27BF
                                                                      \u{1F1E6}-\u{1F1FF}]/x, '')
end

def get_data
    @client = HTTPClient.new
    link1 = "http://review.qunar.com/api/h/shenyang_5577/detail/rank/v1/page/1?__jscallback=&rate=all&onlyGuru=false&_=1436517962412"
    doc1 = Hpricot(@client.get(link1).body)
    res = JSON.parse(doc1.to_s)

    list = res["data"]["list"]
    arr = []
    list.each do |list|
      re_hash = {}
      content = JSON.parse(list["content"])
      hotel_name = content["hotelName"]
      re_hash["hotel_name"] = hotel_name
      if !content["subScores"].empty?
        score_clean = content["subScores"][0]["score"]
        re_hash["score_clean"] = score_clean
        score_infrastructure = content["subScores"][2]["score"]
        re_hash["score_infrastructure"] = score_infrastructure
        score_service = content["subScores"][3]["score"]
        re_hash["score_service"] = score_service
        score_location = content["subScores"][4]["score"]
        re_hash["score_location"] = score_location
      end
      travel_type = content["tripType"]
      re_hash["travel_type"] = travel_type
      title = content["title"]
      re_hash["title"] = title
      desp = content["feedContent"]
      re_hash["desp"] = pass(desp.to_s)
      user_id = list["uid"]
      re_hash["user_id"] = user_id
      user_name = list["nickName"]
      re_hash["user_name"] = user_name
      site = content["detailUrl"]#yonghuxinxi lianjie 
      re_hash["site"] = site
      created_time = content["checkInDate"].gsub(/年/,'')
      re_hash["created_time"] = Time.parse(created_time.gsub(/月/,'')+"01").strftime('%Y-%m-%d %H:%M:%S')
      re_hash["user_name"] = user_name
      score = content["evaluation"]

      arr<<re_hash
    end
    return arr
  end

class HotelComment< ActiveRecord::Base

    res = get_data
    res.each do |res|
        hotel_comment = HotelComment.new(
                                                                                :hotel_id=>42,
                                                                                :created_time=>res["created_time"],
                                                                                :comment_id=> Digest::MD5.hexdigest(res["user_name"]+res["site"]),
                                                                                :site=> res["site"],
                                                                                :hotel_name=>res["hotel_name"],
                                                                                :score_clean=>res["score_clean"],
                                                                                :score_infrastructure=>res["score_infrastructure"],
                                                                                :score_service=>res["score_service"],
                                                                                :score_location=>res["score_location"],
                                                                                :travel_type=>res["travel_type"],
                                                                                :title=>res["title"],
                                                                                :desp=>res["desp"],
                                                                                :user_id=>res["user_id"],
                                                                                :user_name=>res["user_name"]

                                                                                )
        hotel_comment.save
      end

 end

 

 

# f = Roo::Excelx.new("hotels.xlsx") 

# f.default_sheet = f.sheets[0] 

# for i in 2..107
#     #Hotel.create({:name=>f.cell(i,2),:hotel_type=>f.cell(i,1)})
# end


