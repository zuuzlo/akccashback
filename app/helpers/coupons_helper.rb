module CouponsHelper

  def button_link(coupon)
    if logged_in?
      if coupon.coupon_source_id == 1
        @link = coupon.link + "&u1=" + current_user.cashback_id
      else
        @link = coupon.link + "?sid=" + current_user.cashback_id
      end
    else
      if coupon.coupon_source_id == 1
        @link = coupon.link + "&u1=akccb"
      else
        @link = coupon.link + "?sid=akccb"
      end
    end

    if coupon.impression_pixel
      link_to image_tag(coupon.impression_pixel, alt: "#{coupon.title}", size: "1x1") + "Get Deal","#{@link}", class: "btn btn-primary link_button", rel: "nofollow", target: "_blank", "data-container" =>"body", "data-toggle" => "popover", "data-placement" => "right", "data-content" => "Click to get deal at #{coupon.store.name}.", "data-trigger" => "hover"
    else
      link_to "Get Deal","#{@link}", class: "btn btn-primary link_button", rel: "nofollow", target: "_blank", "data-container" =>"body", "data-toggle" => "popover", "data-placement" => "right", "data-content" => "Click to get deal at #{coupon.store.name}.", "data-trigger" => "hover"
    end
  end

  def time_left_display(coupon)
    if coupon.time_difference < 1.day
      capture_haml do
        haml_tag 'span.label.label-danger' do
          haml_tag 'span.glyphicon.glyphicon-time'
          haml_concat "Expires in #{coupon.time_left}"
        end
      end
    elsif coupon.time_difference < 3.day

      capture_haml do
        haml_tag 'span.label.label-warning' do
          haml_tag 'span.glyphicon.glyphicon-time'
          haml_concat "Expires in #{coupon.time_left}"
        end
      end
    else
      capture_haml do
        haml_tag 'span.label.label-success' do
          haml_tag 'span.glyphicon.glyphicon-time'         
          haml_concat "Expires in #{coupon.time_left}"
        end
      end
    end  
  end

  def store_link(controller, coupon)
    if controller == 'stores'
      image_tag( "#{coupon.store_image}" )
    else
      link_to image_tag(coupon.store_image, size: "125x40", alt: coupon.store.name), store_path(coupon.store), class: "store_img", "data-container" =>"body", "data-toggle" => "popover", "data-placement" => "top", "data-content" => "Click to view all #{coupon.store.name} offers.", "data-trigger" => "hover"
    end
  end

  def coupon_type(coupon)
    if coupon.code
      'coupon_codes'
    else
      'offers'
    end
  end

  def favorites(controller, coupon)
    if current_user.coupon_ids.include?(coupon.id)
      link_to toggle_favorite_coupon_path(coupon, coupon_id: coupon.id), method: 'post', remote: true, id: "toggle_favorite_#{coupon.id}", class: "btn btn-default btn-xs" do
        capture_haml do
          haml_tag 'span.glyphicon.glyphicon-remove'
          haml_concat 'Remove from Favorite Coupons'
        end
      end
    else
      link_to toggle_favorite_coupon_path(coupon, coupon_id: coupon.id), method: 'post', remote: true, id: "toggle_favorite_#{coupon.id}", class: "btn btn-default btn-xs" do
        capture_haml do
          haml_tag 'span.glyphicon.glyphicon-ok'
          haml_concat 'Add to Favorite Coupons'
        end
      end
    end
  end

  def product_image(coupon)
    
    if coupon.image
      image_tag("#{coupon.image}", size: "125x125", class: "img-circle")
    else
      image_tag( "#{coupon.store_image}",size: "125x125")
    end
  end
end
