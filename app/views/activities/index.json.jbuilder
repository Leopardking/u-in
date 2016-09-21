json.activities @promotions do |activity|
  json.id activity.id
  json.name activity.name
  json.discount_percent activity.discount_percent
  json.discount_price activity.discount_price
  json.image activity.images.first.image.url(:medium) rescue "0"
end