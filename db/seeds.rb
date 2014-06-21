# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Category.create!( name: 'Apparel', ls_id: '1' )
Category.create!( name: 'Apparel - Babies & Kids', ls_id: '2')
Category.create!( name: 'Apparel - Men\'s', ls_id: '3')
Category.create!( name: 'Apparel - Women\'s', ls_id: '4')
Category.create!( name: 'Automotive', ls_id: '5')
Category.create!( name: 'Beauty & Fragrance', ls_id: '6')
Category.create!( name: 'Book & Magazines', ls_id: '7')
Category.create!( name: 'Cameras & Photography', ls_id: '8')
Category.create!( name: 'Car Rental', ls_id: '9')
Category.create!( name: 'Computers', ls_id: '10')
Category.create!( name: 'Dating', ls_id: '11')
Category.create!( name: 'Department Store', ls_id: '12')
Category.create!( name: 'Electronic Equipment', ls_id: '13')
Category.create!( name: 'Flowers', ls_id: '14')
Category.create!( name: 'Garden & Outdoors', ls_id: '15')
Category.create!( name: 'Gifts', ls_id: '16')
Category.create!( name: 'Gourmet Food & Drink', ls_id: '17')
Category.create!( name: 'Green Products', ls_id: '18')
Category.create!( name: 'Health & Wellness', ls_id: '19')
Category.create!( name: 'Housewares', ls_id: '20')
Category.create!( name: 'Jewelry & Accessories', ls_id: '21')
Category.create!( name: 'Not used', ls_id: '22')
Category.create!( name: 'Music & Movies', ls_id: '23')
Category.create!( name: 'Pet Care', ls_id: '24')
Category.create!( name: 'Services', ls_id: '25')
Category.create!( name: 'Shoes', ls_id: '26')
Category.create!( name: 'Software & Downloads', ls_id: '27')
Category.create!( name: 'Sports & Fitness', ls_id: '28')
Category.create!( name: 'Toys & Games', ls_id: '29')
Category.create!( name: 'Travel & Vacations', ls_id: '30')
Category.create!( name: 'Office & Small Business', ls_id: '31')
Category.create!( name: 'Babies & Kids', ls_id: '32')

Ctype.create!( name: 'General Promotion', ls_id: '1' )
Ctype.create!( name: 'Buy One/ Get One', ls_id: '2' )
Ctype.create!( name: 'Clearance', ls_id: '3' )
Ctype.create!( name: 'Combination Savings', ls_id: '4' )
Ctype.create!( name: 'Dollar Amount Off', ls_id: '5' )
Ctype.create!( name: 'Free Trial / Use', ls_id: '6' )
Ctype.create!( name: 'Free Shipping', ls_id: '7' )
Ctype.create!( name: 'Friends and Family', ls_id: '8' )
Ctype.create!( name: 'Gift with Purchase', ls_id: '9' )
Ctype.create!( name: 'Other', ls_id: '10' )
Ctype.create!( name: 'Percentage Off', ls_id: '11' )
Ctype.create!( name: 'Deal of the Day/Week', ls_id: '14' )
Ctype.create!( name: 'Black Friday', ls_id: '30' )
Ctype.create!( name: 'Cyber Monday', ls_id: '31' )

kcat_hash = { 1 => 'For The Home', 2=> 'Bed & Bath', 3=> 'Furniture', 4=> 'Women', 5=> 'Swin', 6=> 'Men', 7=> 'Teens', 8=> 'Kids', 9=> 'Baby', 10=> 'Shoes', 11=> 'Jewlery & Watches', 12=> 'Sports Fan Shop' }

kcat_hash.each do | id, cat_name |
  KohlsCategory.create!( name: cat_name, kc_id: id )
end

konly_hash = {1 => 'Lauren Conrad', 2 => "Jennifer Lopez", 3 => 'Marc Anthony',
  4 => 'Gold Clearence', 5 => 'Rock & Republic', 6 => "Candie's", 7 => "Dana Buchman", 8 => "Elle" }

konly_hash.each do | id, only_name |
  KohlsOnly.create!( name: only_name, kc_id: id )
end

ktype_hash = { 1 => 'Dollar Off', 2 => 'Percent Off', 3 => 'Free Shipping', 4 => 'Coupon Code', 5 => 'General Promotion', 6 => 'Coupon Code' }

ktype_hash.each do | id, type_name |
  KohlsType.create!( name: type_name, kc_id: id )
end
