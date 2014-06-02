$(document).on("page:change", function(){
  $( ".thumbnail.coupon" ).equalizeHeights()
  $( ".well.store" ).equalizeHeights()
  $(".store_img").popover()
  $(".link_button").popover()
});
$.fn.equalizeHeights = function() {
  var maxHeight = this.map(function( i, e ) {
    return $( e ).height();
  }).get();
  return this.height( Math.max.apply( this, maxHeight ) );
}; 