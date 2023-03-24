json.error do
  json.message object.errors.first.full_message
  json.object object.class.name
end
