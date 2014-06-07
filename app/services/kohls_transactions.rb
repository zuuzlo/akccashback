class KohlsTransactions

  require 'open-uri'
  LsLinkdirectAPI.token = ENV["LINKSHARE_TOKEN"]

  def self.kohls_update_coupons

    textlinks = LsLinkdirectAPI::TextLinks.new
    params = { mid: 38605, cat: -1, endDate: Time.now.strftime("%m%d%Y") }
    response = textlinks.get(params)
    response.data.each do |item|
      coupon_hash = {
        store_id: Store.find_by_id_of_store(item.mid.to_i).id,
        link: item.clickURL,
        id_of_coupon: item.linkID,
        description: item.textDisplay,
        title: LsTransactions.title_shorten("#{item.linkName} #{item.textDisplay}"),
        start_date: Time.parse(item.startDate),
        code: nil, # TODO find(link.couponcode if link.couponcode),
        restriction: "nil",
        image: "TODO",
        impression_pixel: item.showURL,
        coupon_source_id: 1  
      }
    
      if item.endDate == nil || item.endDate == '' || item.endDate.downcase == "ongoing"
        coupon_hash[ :end_date ] = Time.parse('2017-1-1') #DateTime.now + 5.years
      else
        coupon_hash[ :end_date ] = Time.parse(item.endDate)
      end

      new_coupon = Coupon.new(coupon_hash)
      name_check = FindKeywords::Keywords.new("#{item.linkName} #{item.textDisplay}").keywords.join(" ")
      if new_coupon.save
        PjTransactions.pj_find_category(name_check).each do | category |
          new_coupon.categories << Category.find_by_ls_id(category) if category
        end

        PjTransactions.pj_find_type(name_check).each do | type_x |
          new_coupon.ctypes << Ctype.find_by_ls_id(type_x) if type_x
        end
      end
    end
  end
 
  def self.find_kohls_cat(term)
    #1 For The Home, 2 Bed & Bath, 3 Furniture, 4 Women, 5 Swin, 6 Men, 7 Teens, 8 Kids,
    #9 Baby, 10 shoes, 11 Jewlery & Watches, Sports Fan Shop
    kohls_cat_hash = {
      1 => ['patio','grills','outdoor','bbq','hammocks','gazebos','tailgating','garden','bird','stepping','appliances','coffee','tea','cookware','bakeware','cooking','cutlery','cookbooks','food','cleaning','kitchen','rugs','dinnerware','flatware','silverware','table','wine','dining','office','bar','home','speakers','bareware','glassware','serveware','scraper'],
      2 => ['bedskirts','blankets','throws','comforters','comforter','duvet','mattress','mattresses','pillows','shams','quilts','sheets','bedding','towels','towel','shower','bath','personal'],
      3 => ['furniture','art','candles','decorative','lighting','lamp','lamps','frames','albums','cushions','slipcovers','rugs','treatments'],
      4 => ['women','women\'s','capris','dresses','intimates','bras','panties','shapewear','handbags'],
      5 => ['swimsuit','tankini','bikini','cover-ups'],
      6 => ['men','men\'s','polos','ties','urban'],
      7 => ['teen','teen\'s','prom','juniors','girls','boys'],
      8 => ['kids','toddler','toys'],
      9 => ['baby','stroller','carriers','diaper','babies','infant','infants','newborns'],
      10 => ['shoes','boot','boots','clogs','flats','flip-flops','pumps','heels','oxfords','sandals','slippers','wedges','loafers','cleats'],
      11 => ['jewelry','watches','watch','rings','necklaces','earrings','bracelets','beads','charms','gemstones','diamonds','pins','diamond','pearl'],
      12 => ['ncaa','mlb','nfl','nba','nhl','olympics','nascar','soccer','basketball','fan']
    }

    cloths = ['capris','coats','coat','dresses','dress','jackets','jacket','blazers','blazer','jeans','pants','leggings','shirts','tees','shirt','tee','shorts','skirt','skirts','pajamas','robes','robe','suit','suits','sweater','sweaters','workout','socks','underwear','belt','tops','top','yoga','active','clothes','activewear','sonoma','jeggings']
    categories = []
    kohls_cat_hash.each do | cat_id, match_words |
      categories << cat_id if have_term?(match_words, term)
    end

    if categories.count == 0
      categories << 4 if have_term?(cloths, term)
    end

    categories
  end

  def self.find_kohls_only(term)
    #1 Lauren Conrad, 2 Jennifer Lopez, 3 Marc Anthony, 4 Gold Clearence, 5 Rock & Republic
    #6 Candie's, 7 Dana Buchman, 8 Elle
    kohls_only_hash = {
      1 => ['lauren','conrad'],
      2 => ['jennifer','lopez'],
      3 => ['marc','anthony'],
      4 => ['gold','clearance'],
      5 => ['rock','republic'],
      6 => ['candies'],
      7 => ['dana','Buchman'],
      8 => ['elle']
    }

    onlys = []
    kohls_only_hash.each do | cat_id, match_words |
      onlys << cat_id if have_term?(match_words, term)
    end
    onlys
  end

  private

  def self.have_term?(words, term)
    if words.select{ |word| term.downcase.insert(0," ").include? word.insert(0," ") }.join("") == ""
      return false
    end
    true
  end
end