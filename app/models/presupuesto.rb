# == Schema Information
#
# Table name: presupuestos
#
#  id          :bigint           not null, primary key
#  description :text
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  event_id    :bigint           not null
#
# Indexes
#
#  index_presupuestos_on_event_id  (event_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
class Presupuesto < ApplicationRecord
  belongs_to :event
  has_many :lineas, dependent: :destroy

  validates :title, presence: true

  def total_general
    lineas.where(por_persona: false).sum(&:valor_cents) || 0
  end

  def total_por_persona
    lineas.where(por_persona: true).sum(&:valor_cents) || 0
  end

  def total_para_evento
    return 0 if event.invitations.empty?

    confirmados = event.invitations.where(status: "accepted").count
    confirmados = 1 if confirmados.zero? # Al menos una persona

    general = total_general
    por_persona = total_por_persona * confirmados

    general + por_persona
  end

  def costo_por_persona
    return 0 if event.invitations.empty?

    confirmados = event.invitations.where(status: "accepted").count
    confirmados = 1 if confirmados.zero? # Al menos una persona

    total_para_evento / confirmados
  end

  # Métodos para calcular con todos los invitados (confirmados + pendientes)
  def total_para_evento_todos
    return 0 if event.invitations.empty?

    todos = event.invitations.where(status: [ "accepted", "pending" ]).count
    todos = 1 if todos.zero? # Al menos una persona

    general = total_general
    por_persona = total_por_persona * todos

    general + por_persona
  end

  def costo_por_persona_todos
    return 0 if event.invitations.empty?

    todos = event.invitations.where(status: [ "accepted", "pending" ]).count
    todos = 1 if todos.zero? # Al menos una persona

    total_para_evento_todos / todos
  end
end
