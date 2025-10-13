#!/usr/bin/env ruby

# Script para automatizar la conversión de textos literales a traducciones
# Uso: ruby migrate_translations.rb

require 'fileutils'

# Mapeo de textos comunes que se repiten
COMMON_TRANSLATIONS = {
  # Acciones
  "Editar" => "t('common.edit')",
  "Eliminar" => "t('common.delete')",
  "Guardar" => "t('common.save')",
  "Cancelar" => "t('common.cancel')",
  "Crear" => "t('common.create')",
  "Actualizar" => "t('common.update')",
  "Confirmar" => "t('common.confirm')",
  "Compartir" => "t('common.share')",
  "Volver" => "t('navigation.back')",

  # Campos de formulario
  "Nombre" => "t('common.name')",
  "Título" => "t('common.title')",
  "Descripción" => "t('common.description')",
  "Fecha" => "t('common.date')",
  "Ubicación" => "t('common.location')",
  "Email" => "t('common.email')",

  # Estados
  "Pendiente" => "t('invitations.pending')",
  "Confirmado" => "t('invitations.confirmed')",
  "Rechazado" => "t('invitations.declined')",

  # Presupuesto
  "Total" => "t('common.total')",
  "Presupuesto" => "t('budget.title')",

  # Eventos
  "Eventos" => "t('events.title')",
  "Nuevo Evento" => "t('events.new_event')",
  "Crear Evento" => "t('events.create_event')",

  # Regalos
  "Lista de Regalos" => "t('gifts.title')",
  "Registrar Regalo" => "t('gifts.register_gift')",
  "Nombre del Regalo" => "t('gifts.gift_name')",

  # Confirmaciones
  "¿Estás seguro?" => "t('common.confirm')",
  "¿Estás seguro de que quieres eliminar" => "t('common.delete_confirm')"
}

def replace_in_file(file_path, replacements)
  return unless File.exist?(file_path)

  content = File.read(file_path)
  original_content = content.dup

  replacements.each do |original, translation|
    # Reemplazar texto entre comillas dobles
    content.gsub!(/\"#{Regexp.escape(original)}\"/, "<%= #{translation} %>")
    # Reemplazar texto entre comillas simples
    content.gsub!(/'#{Regexp.escape(original)}'/, "<%= #{translation} %>")
    # Reemplazar texto literal en algunos contextos específicos
    content.gsub!(/#{Regexp.escape(original)}(?=\s*<\/)/m, "<%= #{translation} %>")
  end

  if content != original_content
    File.write(file_path, content)
    puts "✅ Actualizado: #{file_path}"
    true
  else
    puts "⚪ Sin cambios: #{file_path}"
    false
  end
end

# Buscar todos los archivos de vista
view_files = Dir.glob("app/views/**/*.{erb,html.erb}")

puts "🚀 Iniciando migración de traducciones..."
puts "📁 Archivos encontrados: #{view_files.count}"
puts

updated_count = 0

view_files.each do |file|
  if replace_in_file(file, COMMON_TRANSLATIONS)
    updated_count += 1
  end
end

puts
puts "✨ Migración completada!"
puts "📊 Archivos actualizados: #{updated_count}/#{view_files.count}"
puts
puts "⚠️  Recuerda revisar manualmente los archivos para:"
puts "   - Verificar que las traducciones están correctas"
puts "   - Ajustar contextos específicos"
puts "   - Agregar traducciones faltantes a los archivos YML"
