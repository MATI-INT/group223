class Numeric
  CONVERSIONS = {
      euro: 80,
      dollar: 71
  }

  def method_missing(method_name)
    currency = method_name.to_s.gsub(/s\z/i, '').to_sym
    if CONVERSIONS.has_key?(currency)
      self * CONVERSIONS[currency]
    else
      super
    end
  end
end

sum = 40
puts sum.euros