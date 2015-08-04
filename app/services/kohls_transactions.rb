class KohlsTransactions

  require 'open-uri'
  LsLinkdirectAPI.token = ENV["LINKSHARE_TOKEN"]
  LinkshareAPI.token = ENV["LINKSHARE_TOKEN"]

  def self.kohls_update_coupons
    textlinks = LsLinkdirectAPI::TextLinks.new
    params = { mid: 38605, cat: -1, endDate: Time.now.strftime("%m%d%Y") }
    response = textlinks.get(params)
    response.data.each do |item|
      coupon_hash = {
        store_id: Store.find_by_id_of_store(item.mid.to_i).id,
        link: item.clickURL,
        id_of_coupon: item.linkID.to_i,
        description: "#{item.linkName} #{item.textDisplay}",
        title: LsTransactions.title_shorten("#{item.textDisplay}"),
        start_date: Time.parse(item.startDate),
        code: find_coupon_code("#{item.textDisplay}"),
        restriction: nil,
        impression_pixel: item.showURL,
        coupon_source_id: 1  
      }
  
      unless RemovedCoupon.pluck(:id_of_coupon).include? coupon_hash[:id_of_coupon]
        if item.endDate == nil || item.endDate == '' || item.endDate.downcase == "ongoing"
          coupon_hash[ :end_date ] = Time.parse('2017-1-1') #DateTime.now + 5.years
        else
          coupon_hash[ :end_date ] = Time.parse(item.endDate)
        end

        new_coupon = Coupon.new(coupon_hash)
        name_check = FindKeywords::Keywords.new("#{item.linkName} #{item.textDisplay} #{item.categoryName}").keywords.join(" ")
        name_check_raw = "#{item.linkName} #{item.textDisplay} #{item.categoryName}"
        
        if new_coupon.save
=begin
          PjTransactions.pj_find_category(name_check).each do | cat |
            new_coupon.categories << Category.find_by_ls_id(cat) if cat
          end

          PjTransactions.pj_find_type(name_check_raw).each do | type_x |
            new_coupon.ctypes << Ctype.find_by_ls_id(type_x) if type_x
          end
=end
          find_kohls_cat(name_check).each do | kohls_cat |
            new_coupon.kohls_categories << KohlsCategory.find_by_kc_id(kohls_cat) if kohls_cat
          end

          find_kohls_only(name_check).each do | only_kohls |
            new_coupon.kohls_onlies << KohlsOnly.find_by_kc_id(only_kohls) if only_kohls
          end

          find_kohls_type(name_check_raw).each do | type_kohls |
            new_coupon.kohls_types << KohlsType.find_by_kc_id(type_kohls) if type_kohls
          end
        
          #new_coupon.kohls_types << KohlsType.find_by_kc_id(6) if new_coupon.code
          
          new_coupon.remote_image_url = find_product_image(name_check)
          new_coupon.save
        end
      end
    end
    Coupon.all.each { |c| c.touch }
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

  def self.find_kohls_type(term)
    #1=> 'Dollar Off', 2=> 'Percent Off', 3=> 'Free Shipping', 4=>'Coupon Code', 5=>'General Promotion'
    term.downcase!
    kohls_type_hash = {
      1 => [/\$/],
      2 => [/\%/],
      3 => [/free shipping/, /ships free/],
      4 => [/code/],
      6 => [/sitewide/]
    }

    types = []
    
    kohls_type_hash.each do | cat_id, match_words |
      match_words.each do | match_word |
        types << cat_id if term =~ match_word
      end
    end
    #types << 2 if term.include? '% '
    types << 5 if types.count == 0
    
    types.uniq   
  end

  def self.find_coupon_code(term)
    if term.include? " "
      code_array = ["code","code:", "Code", "Code:"]
      term_array = term.split(" ").collect(&:strip)
      code_have = []
      #require 'pry'; binding.pry
      code_array.each do | code |
        code_have << code if term_array.include?("#{code}")
      end
      
      if code_have.size != 0
        term_array[term_array.index(code_have[0]).to_i + 1].gsub!(/[^a-zA-Z0-9]/,'')
      else
        nil
      end
    else
      nil
    end
  end

  def self.find_product_image(keywords)
    keywords = 'kohls' if keywords == ""
    options = {
      one: keywords,
      mid: 38605, # kohls
      #cat: "Electronics",
      max: 1,
      #sort: :retailprice,
      #sorttype: :asc
    }
    response = LinkshareAPI.product_search(options)

    if response.total_matches == 0
      nil
    else
      response.data.first.imageurl
    end
  end

  private

  def self.have_term?(words, term)
    if words.select{ |word| term.downcase.insert(0," ").include? word.insert(0," ") }.join("") == ""
      return false
    end
    true
  end
end