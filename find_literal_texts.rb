#!/usr/bin/env ruby

# Script para identificar textos literales en las vistas que necesitan traducción
# Uso: ruby find_literal_texts.rb

require 'find'

# Patrones para identificar textos literales en español
SPANISH_PATTERNS = [
  /["']([^"']*[áéíóúüñ¿¡][^"']*?)["']/,  # Textos con caracteres españoles
  /["']([^"']*\b(?:el|la|los|las|de|del|que|para|con|por|en|un|una|este|esta|estos|estas|son|es|está|están|tienen|tiene|hacer|crear|editar|eliminar|guardar|confirmar|cancelar|volver|nuevo|nueva|gestionar|administrar|compartir|enviar|registrar|lista|evento|eventos|regalo|regalos|invitación|invitaciones|presupuesto|grupo|familia|tema|detalles|descripción|fecha|hora|ubicación|nombre|email|teléfono|estado|pendiente|confirmado|rechazado|pagado|total|estimado|real|restante|asistencia|solicitudes|restricciones|miembros|color|fondo|error|éxito|advertencia|consejo|tip|sí|no|tal vez|vez)\b[^"']*?)["']/i
]

def find_literal_texts_in_file(file_path)
  content = File.read(file_path)
  found_texts = []

  # Buscar patrones de textos en español
  SPANISH_PATTERNS.each do |pattern|
    content.scan(pattern) do |match|
      text = match[0]
      next if text.nil? || text.strip.empty?
      next if text.match?(/^[A-Z_]+$/) # Skip constants
      next if text.match?(/^\s*$/) # Skip whitespace only
      next if text.match?(/^[\w\-\.\/]+$/) # Skip paths/urls/ids
      next if text.match?(/^#[0-9a-fA-F]{3,6}$/) # Skip hex colors
      next if text.include?('<%') || text.include?('%>') # Skip ERB code

      found_texts << {
        text: text,
        pattern: pattern,
        line_number: content[0..content.index(text)].count("\n") + 1
      }
    end
  end

  found_texts.uniq { |item| item[:text] }
end

# Buscar en todas las vistas
view_files = []
Find.find('./app/views') do |path|
  if path.end_with?('.html.erb', '.erb')
    view_files << path
  end
end

all_texts = {}

view_files.each do |file|
  texts = find_literal_texts_in_file(file)
  if texts.any?
    all_texts[file] = texts
  end
end

# Mostrar resultados
puts "📝 Textos literales encontrados en las vistas:\n\n"

all_texts.each do |file, texts|
  puts "📁 #{file}"
  puts "=" * 50

  texts.each do |item|
    puts "  Línea #{item[:line_number]}: \"#{item[:text]}\""
  end

  puts "\n"
end

puts "\n✅ Búsqueda completada. Archivos analizados: #{view_files.count}"
puts "📊 Textos encontrados: #{all_texts.values.flatten.count}"
