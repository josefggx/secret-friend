json.data do
  json.array! @workers do |worker|
    json.id worker.id
    json.title worker.name
    json.location worker.location.name
    json.year_in_work worker.year_in_work
  end
end