json.data do
  json.id @worker.id
  json.name @worker.name
  json.location @worker.location.name
  json.year_in_work @worker.year_in_work
end
