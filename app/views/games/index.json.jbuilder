json.data do
  json.array! @games do |game|
    json.id game.id
    json.title game.name
  end
end