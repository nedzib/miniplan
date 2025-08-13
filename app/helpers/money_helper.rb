module MoneyHelper
  def format_money(amount_cents, currency = "USD")
    if amount_cents.is_a?(Numeric)
      amount = amount_cents / 100.0

      # Formatear el número con separadores de miles
      formatted_amount = number_with_delimiter(sprintf("%.2f", amount), delimiter: ".", separator: ",")

      case currency.upcase
      when "USD"
        "$#{formatted_amount}"
      when "EUR"
        "€#{formatted_amount}"
      when "COP", "PESOS"
        "$#{formatted_amount} COP"
      else
        "#{currency} #{formatted_amount}"
      end
    else
      "$0,00"
    end
  end

  # Alias para compatibilidad con MoneyRails
  def humanized_money_with_symbol(amount_cents, currency = "USD")
    format_money(amount_cents, currency)
  end
end
