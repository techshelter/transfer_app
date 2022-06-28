def numeric?(value)
  Float(value) != nil rescue false
end
Dry::Validation.register_macro(:numeric) do
  unless numeric?(value)
    key.failure('should contain only numbers')
  end
end
