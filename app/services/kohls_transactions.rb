class KohlsTransactions

  require 'open-uri'
  LsLinkdirectAPI.token = ENV["LINKSHARE_TOKEN"]

  def self.kohls_update_coupons

    textlinks = LsLinkdirectAPI::TextLinks.new
    params = { mid: 38605, cat: -1, endDate: Time.now.strftime("%m%d%Y") }
    # all params are optional gem will add defaults where required
    response = textlinks.get(params)
    response.data.each do |item|
      coupon_hash = {
        store_id: Store.find_by_id_of_store(item.mid.to_i).id,
        link: item.clickURL,
        id_of_coupon: item.linkID,
        description: item.textDisplay,
        title: LsTransactions.title_shorten("#{item.linkName} #{item.textDisplay}"),
        start_date: Time.parse(item.startDate),
        code: # TODO find(link.couponcode if link.couponcode),
        restriction: "nil",
        image: TODO,
        impression_pixel: item.showURL,
        coupon_source_id: 1  
      }

      if item.endDate == '' || item.endDate.downcase == "ongoing"
        coupon_hash[ :end_date ] = Time.parse('2017-1-1') #DateTime.now + 5.years
      else
        coupon_hash[ :end_date ] = Time.parse(item.endDate)
      end

      new_coupon = Coupon.new(coupon_hash)
      
      if new_coupon.save
  
        link.categories.category.each do | category |
          new_coupon.categories << Category.find_by_ls_id(category["id"].to_i) if category["id"]
        end

        link.promotiontypes.promotiontype.each do | type_x |
          new_coupon.ctypes << Ctype.find_by_ls_id(type_x["id"].to_i) if type_x["id"]
        end
      end
    end
  end
end