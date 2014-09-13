desc "This task is called by the Heroku scheduler add-on"
task :update_coupons => :environment do
  puts "Updating coupons..."
  KohlsTransactions.kohls_update_coupons
  puts "done."
end

task :update_activity => :environment do
  puts "Updating activity..."
  LsTransactions.ls_activity
  puts "done."
end