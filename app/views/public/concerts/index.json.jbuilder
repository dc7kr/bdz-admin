json.array! @concerts do |concert|
  json.start concert.concert_date
  json.id concert.id
  json.title concert.titel
end
