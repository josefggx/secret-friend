json.data do
  json.array! @locations do |location|
    json.id location.id
    json.name location.name
  end
end