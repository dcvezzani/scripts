#!/bin/bash

#...............................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................

total=0
counts=('')
for file in spec/lib/shared/sinewave/password_checker_spec.rb spec/lib/shared/sinewave/sync/active_record_callbacks_spec.rb spec/lib/shared/sinewave/sync/customer_formatter_spec.rb spec/lib/shared/sinewave/sync/formatter_spec.rb spec/lib/shared/sinewave/sync/importer_spec.rb spec/lib/shared/sinewave/sync/queue_spec.rb spec/lib/shared/sinewave/sync/sender_spec.rb spec/lib/shared/sinewave/uri_builder_spec.rb spec/lib/shared/sinewave/user_info_updater_spec.rb spec/lib/shared/sinewave/user_spec.rb spec/lib/shared/sort_line_items_spec.rb spec/lib/shared/weight_spec.rb spec/lib/store_setup_spec.rb spec/lib/sunspot/cleanup_spec.rb spec/lib/sunspot/solr_check_spec.rb spec/mailers/alert_mailer_spec.rb spec/mailers/bug_report_mailer_spec.rb spec/mailers/buy_order_mailer_spec.rb spec/mailers/customer_notify_spec.rb spec/mailers/feedback_mailer_spec.rb spec/mailers/internal_notification_mailer_spec.rb spec/mailers/order_mailer_spec.rb spec/mailers/refer_a_friend_mailer_spec.rb spec/mailers/reserved_quantity_report_mailer_spec.rb spec/mailers/wishlist_mailer_spec.rb spec/models/activity_log_spec.rb spec/models/address_spec.rb spec/models/api/v1/report_spec.rb spec/models/api/v1/webhook_envelope_spec.rb spec/models/api/v1/webhook_spec.rb spec/models/batch_update_process_element_spec.rb spec/models/batch_update_process_spec.rb spec/models/batch_update_spec.rb spec/models/bulk_import_row_spec.rb spec/models/bulk_import_spec.rb spec/models/buy_order_line_item_spec.rb spec/models/buy_order_splitter_spec.rb spec/models/canadian_tax_rate_policy_spec.rb spec/models/canadian_tax_table_spec.rb spec/models/cash_drawer_activity_spec.rb spec/models/cash_drawer_spec.rb spec/models/catalog_group_spec.rb spec/models/catalog_product_spec.rb spec/models/category_spec.rb spec/models/channel_catalog_state_spec.rb spec/models/client_api_spec.rb spec/models/contact_us_submission_spec.rb spec/models/coupon_application_spec.rb spec/models/coupon_payment_spec.rb spec/models/coupon_redemption_spec.rb spec/models/coupon_spec.rb spec/models/credit_debit_spec.rb spec/models/current_user_spec.rb spec/models/custom_line_item_spec.rb spec/models/custom_ship_method_spec.rb spec/models/customer_field_spec.rb; do
  count=$(cat "$file" | grep 'it "' | wc -l | xargs)
  total=$((total + count))
  echo -e "\n$file:"
  rspec_results="$(bin/rspec "$file" 2>&1)"
  echo "$rspec_results"
  timer=$(echo "$rspec_results" | grep 'Finished in ' | sed -E '/seconds/!d; s/Finished in ([^[:space:]]+) seconds/\1/g')
  counts+=("$count:$total:$timer:$file")
done
echo "$total"
echo "${counts[@]}"

