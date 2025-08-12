# Crear usuarios
puts "Creando usuarios..."
user1 = User.create!(
  email_address: "carlos.martinez@email.com",
  password: "password123"
)

user2 = User.create!(
  email_address: "ana.rodriguez@email.com",
  password: "password123"
)

# Crear eventos
puts "Creando eventos..."
wedding = Event.create!(
  title: "Boda de Carlos y Ana",
  description: "Celebración de nuestra boda. ¡Los esperamos!",
  start_time: 3.weeks.from_now.change(hour: 18, min: 0),
  end_time: 3.weeks.from_now.change(hour: 23, min: 59),
  location: "Hacienda Los Laureles, Medellín",
  user: user1
)

birthday = Event.create!(
  title: "Cumpleaños de Ana",
  description: "Celebración del cumpleaños número 30 de Ana",
  start_time: 6.weeks.from_now.change(hour: 19, min: 0),
  end_time: 6.weeks.from_now.change(hour: 23, min: 0),
  location: "Casa de Ana, Envigado",
  user: user2
)

graduation = Event.create!(
  title: "Graduación de María",
  description: "Ceremonia de graduación y celebración posterior",
  start_time: 8.weeks.from_now.change(hour: 15, min: 0),
  end_time: 8.weeks.from_now.change(hour: 20, min: 0),
  location: "Universidad Nacional, Bogotá",
  user: user1
)

# Crear invitaciones individuales para la boda
puts "Creando invitaciones para la boda..."
wedding_invitations = [
  # Familia Gómez
  { name: "Pedro Gómez", email: "pedro.gomez@email.com", phone: "+57 300 123 4567" },
  { name: "María Gómez", email: "maria.gomez@email.com", phone: "+57 300 123 4568" },
  { name: "Sofía Gómez", email: "sofia.gomez@email.com", phone: "+57 300 123 4569" },
  { name: "Andrés Gómez", email: "andres.gomez@email.com", phone: "+57 300 123 4570" },

  # Familia Ruiz
  { name: "Roberto Ruiz", email: "roberto.ruiz@email.com", phone: "+57 301 234 5678" },
  { name: "Carmen Ruiz", email: "carmen.ruiz@email.com", phone: "+57 301 234 5679" },
  { name: "Diego Ruiz", email: "diego.ruiz@email.com", phone: "+57 301 234 5680" },

  # Amigos del colegio
  { name: "Laura Pérez", email: "laura.perez@email.com", phone: "+57 302 345 6789" },
  { name: "David Morales", email: "david.morales@email.com", phone: "+57 302 345 6790" },
  { name: "Camila Torres", email: "camila.torres@email.com", phone: "+57 302 345 6791" },
  { name: "Sebastián López", email: "sebastian.lopez@email.com", phone: "+57 302 345 6792" },

  # Familia extendida
  { name: "Lucia Herrera", email: "lucia.herrera@email.com", phone: "+57 303 456 7890" },
  { name: "Fernando Herrera", email: "fernando.herrera@email.com", phone: "+57 303 456 7891" },
  { name: "Isabella Herrera", email: "isabella.herrera@email.com", phone: "+57 303 456 7892" },

  # Compañeros de trabajo
  { name: "Alejandro Silva", email: "alejandro.silva@email.com", phone: "+57 304 567 8901" },
  { name: "Valentina Castro", email: "valentina.castro@email.com", phone: "+57 304 567 8902" },
  { name: "Nicolás Vargas", email: "nicolas.vargas@email.com", phone: "+57 304 567 8903" },

  # Invitados individuales
  { name: "Diana Jiménez", email: "diana.jimenez@email.com", phone: "+57 305 678 9012" },
  { name: "Gabriel Restrepo", email: "gabriel.restrepo@email.com", phone: "+57 305 678 9013" },
  { name: "Paola Mejía", email: "paola.mejia@email.com", phone: "+57 305 678 9014" }
]

# Crear las invitaciones con diferentes estados
wedding_invites = wedding_invitations.map.with_index do |invite_data, index|
  status = case index % 4
  when 0 then :accepted
  when 1 then :pending
  when 2 then :accepted
  when 3 then :declined
  end

  Invitation.create!(
    event: wedding,
    name: invite_data[:name],
    email: invite_data[:email],
    phone: invite_data[:phone],
    status: status
  )
end

# Crear grupos familiares para la boda
puts "Creando grupos familiares para la boda..."
familia_gomez = FamilyGroup.create!(
  name: "Familia Gómez",
  event: wedding
)

familia_ruiz = FamilyGroup.create!(
  name: "Familia Ruiz",
  event: wedding
)

amigos_colegio = FamilyGroup.create!(
  name: "Amigos del Colegio",
  event: wedding
)

familia_herrera = FamilyGroup.create!(
  name: "Familia Herrera",
  event: wedding
)

compañeros_trabajo = FamilyGroup.create!(
  name: "Compañeros de Trabajo",
  event: wedding
)

# Asignar invitaciones a grupos familiares
puts "Asignando invitaciones a grupos familiares..."
# Familia Gómez (primeros 4)
wedding_invites[0..3].each { |invite| invite.update!(family_group: familia_gomez) }

# Familia Ruiz (siguientes 3)
wedding_invites[4..6].each { |invite| invite.update!(family_group: familia_ruiz) }

# Amigos del colegio (siguientes 4)
wedding_invites[7..10].each { |invite| invite.update!(family_group: amigos_colegio) }

# Familia Herrera (siguientes 3)
wedding_invites[11..13].each { |invite| invite.update!(family_group: familia_herrera) }

# Compañeros de trabajo (siguientes 3)
wedding_invites[14..16].each { |invite| invite.update!(family_group: compañeros_trabajo) }

# Los últimos 3 quedan como invitados individuales (sin grupo familiar)

# Crear invitaciones para el cumpleaños (evento más pequeño)
puts "Creando invitaciones para el cumpleaños..."
birthday_invitations = [
  { name: "Carlos Martínez", email: "carlos.martinez@email.com", phone: "+57 300 111 2222", status: :accepted },
  { name: "Sofía Gómez", email: "sofia.gomez@email.com", phone: "+57 300 123 4569", status: :accepted },
  { name: "Laura Pérez", email: "laura.perez@email.com", phone: "+57 302 345 6789", status: :pending },
  { name: "David Morales", email: "david.morales@email.com", phone: "+57 302 345 6790", status: :accepted },
  { name: "Camila Torres", email: "camila.torres@email.com", phone: "+57 302 345 6791", status: :declined },
  { name: "Valentina Castro", email: "valentina.castro@email.com", phone: "+57 304 567 8902", status: :accepted },
  { name: "Diana Jiménez", email: "diana.jimenez@email.com", phone: "+57 305 678 9012", status: :pending },
  { name: "Patricia Moreno", email: "patricia.moreno@email.com", phone: "+57 306 789 0123", status: :accepted },
  { name: "Andrea Salazar", email: "andrea.salazar@email.com", phone: "+57 307 890 1234", status: :accepted },
  { name: "Miguel Cárdenas", email: "miguel.cardenas@email.com", phone: "+57 308 901 2345", status: :pending }
]

birthday_invites = birthday_invitations.map do |invite_data|
  Invitation.create!(
    event: birthday,
    name: invite_data[:name],
    email: invite_data[:email],
    phone: invite_data[:phone],
    status: invite_data[:status]
  )
end

# Crear algunos grupos familiares para el cumpleaños
familia_cercana_birthday = FamilyGroup.create!(
  name: "Familia Cercana",
  event: birthday
)

amigas_universidad = FamilyGroup.create!(
  name: "Amigas de la Universidad",
  event: birthday
)

# Asignar algunos invitados a grupos
birthday_invites[0..2].each { |invite| invite.update!(family_group: familia_cercana_birthday) }
birthday_invites[5..7].each { |invite| invite.update!(family_group: amigas_universidad) }

# Crear invitaciones para la graduación
puts "Creando invitaciones para la graduación..."
graduation_invitations = [
  { name: "Ana Rodríguez", email: "ana.rodriguez@email.com", phone: "+57 300 222 3333", status: :accepted },
  { name: "Pedro Gómez", email: "pedro.gomez@email.com", phone: "+57 300 123 4567", status: :accepted },
  { name: "María Gómez", email: "maria.gomez@email.com", phone: "+57 300 123 4568", status: :accepted },
  { name: "Roberto Silva", email: "roberto.silva@email.com", phone: "+57 309 012 3456", status: :pending },
  { name: "Elena Ramírez", email: "elena.ramirez@email.com", phone: "+57 310 123 4567", status: :accepted },
  { name: "Jorge Mendoza", email: "jorge.mendoza@email.com", phone: "+57 311 234 5678", status: :accepted },
  { name: "Claudia Vega", email: "claudia.vega@email.com", phone: "+57 312 345 6789", status: :declined },
  { name: "Tomás Guerrero", email: "tomas.guerrero@email.com", phone: "+57 313 456 7890", status: :accepted }
]

graduation_invites = graduation_invitations.map do |invite_data|
  Invitation.create!(
    event: graduation,
    name: invite_data[:name],
    email: invite_data[:email],
    phone: invite_data[:phone],
    status: invite_data[:status]
  )
end

# Crear grupos para la graduación
familia_graduada = FamilyGroup.create!(
  name: "Familia de María",
  event: graduation
)

compañeros_universidad = FamilyGroup.create!(
  name: "Compañeros de Universidad",
  event: graduation
)

# Asignar invitados a grupos
graduation_invites[0..2].each { |invite| invite.update!(family_group: familia_graduada) }
graduation_invites[4..6].each { |invite| invite.update!(family_group: compañeros_universidad) }

puts "🎉 Seeds creadas exitosamente!"
puts ""
puts "📊 Resumen:"
puts "- #{User.count} usuarios creados"
puts "- #{Event.count} eventos creados"
puts "- #{Invitation.count} invitaciones creadas"
puts "- #{FamilyGroup.count} grupos familiares creados"
puts ""
puts "🎪 Eventos:"
Event.all.each do |event|
  accepted_count = event.invitations.accepted.count
  pending_count = event.invitations.pending.count
  declined_count = event.invitations.declined.count
  groups_count = event.family_groups.count

  puts "  #{event.title}:"
  puts "    - #{event.invitations.count} invitaciones totales"
  puts "    - #{accepted_count} aceptadas, #{pending_count} pendientes, #{declined_count} rechazadas"
  puts "    - #{groups_count} grupos familiares"
  puts "    - #{event.invitations.where(family_group: nil).count} invitados individuales"
  puts ""
end
