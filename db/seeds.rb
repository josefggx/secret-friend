location1 = Location.create(name: 'Tech')
location2 = Location.create(name: 'Finanzas')

10_000.times do |i|
  name = "Worker#{i + 1}"
  location = i.even? ? location1 : location2
  Worker.create(name: name, location_id: location.id)
end

# Worker.create(name: 'Jose', location_id: location1.id)
# Worker.create(name: 'Amy', location_id: location2.id)
# Worker.create(name: 'Dani', location_id: location2.id)
