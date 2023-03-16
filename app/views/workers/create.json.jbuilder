json.data do
  json.worker do
    json.id @worker.id
    json.title @worker.name
    json.location @worker.location.name
    json.year_in_work @worker.year_in_work
    # json.worker_couples @worker.couples
  end
end