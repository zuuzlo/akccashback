module ApplicationHelper

  def user_home?
    if params[:id]
      param = "id"
    else
      param = "user_id"
    end

    if params[param.to_sym] == current_user.slug
      true
    else
      false
    end
  end

  def filt_page?
    if ['kohls_categories', 'kohls_types', 'kohls_onlies', 'coupons'].include?(params[:controller])
      true
    else
      false
    end
  end

  def full_title(page_title)
    base_title = "Cash Back at Kohls: 30% Promo Codes, Kohls Coupon Codes"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title} Coupons and Deals".html_safe
    end
  end
end
