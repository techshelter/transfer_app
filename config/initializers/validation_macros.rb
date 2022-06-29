def numeric?(value)
  Float(value) != nil rescue false
end
Dry::Validation.register_macro(:numeric) do
  unless numeric?(value)
    key.failure('should contain only numbers')
  end
end

Dry::Validation.register_macro(:uuid) do
  if UUID.validate(value).nil?
    key.failure('not a valid ID')
  end
end
