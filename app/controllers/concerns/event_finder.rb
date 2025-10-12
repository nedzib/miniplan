module EventFinder
  extend ActiveSupport::Concern

  private

  def find_event_by_param(param_value)
    return nil unless param_value

    # Si el parámetro parece ser un hash_id (hexadecimal de 32 caracteres), buscar por hash_id
    if param_value.match?(/\A[a-f0-9]{32}\z/)
      Event.find_by!(hash_id: param_value)
    else
      # Si es un número, buscar por id (para compatibilidad con links antiguos)
      Event.find(param_value)
    end
  end
end
