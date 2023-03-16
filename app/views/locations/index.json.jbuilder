json.data do
  json.array! @locations do |location|
    json.id location.id
    json.title location.name
  end
end