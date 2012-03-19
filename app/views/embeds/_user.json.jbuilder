if user.present?
  json.(user, :id, :name)
end
