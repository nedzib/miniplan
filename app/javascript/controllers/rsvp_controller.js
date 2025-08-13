import { Controller } from "@hotwired/stimulus"
import confetti from "canvas-confetti"

export default class extends Controller {
  static targets = ["acceptButton", "declineButton", "confirmationSection", "responseSection", "statusIndicator"]
  static values = { invitationId: Number }

  connect() {
    console.log("RSVP controller connected")
  }

  async accept(event) {
    event.preventDefault()
    await this.updateRSVP('accepted')
    await this.showConfirmation('accepted')
    this.updateStatusIndicator('accepted')
    this.launchConfetti()
  }

  async decline(event) {
    event.preventDefault()
    await this.updateRSVP('declined')
    await this.showConfirmation('declined')
    this.updateStatusIndicator('declined')
  }

  async updateRSVP(status) {
    try {
      const response = await fetch(`/invitations/${this.invitationIdValue}/rsvp`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({ status: status })
      })

      if (!response.ok) {
        throw new Error('Error updating RSVP')
      }
    } catch (error) {
      console.error('Error:', error)
      alert('Hubo un error al procesar tu respuesta. Por favor intenta de nuevo.')
    }
  }

  async showConfirmation(status) {
    this.confirmationSectionTarget.classList.add('hidden')
    
    try {
      const partialName = status === 'accepted' ? 'accepted_response' : 'declined_response'
      const response = await fetch(`/rsvp/partial/${partialName}`)
      const html = await response.text()
      
      this.responseSectionTarget.innerHTML = html
      this.responseSectionTarget.classList.remove('hidden')
    } catch (error) {
      console.error('Error loading partial:', error)
      // Fallback to inline templates if partial loading fails
      this.responseSectionTarget.innerHTML = status === 'accepted' ? this.getAcceptedTemplate() : this.getDeclinedTemplate()
      this.responseSectionTarget.classList.remove('hidden')
    }
  }

  launchConfetti() {
    // Bee-themed confetti with golden colors
    confetti({
      particleCount: 100,
      spread: 70,
      origin: { y: 0.6 },
      colors: ['#FFD700', '#FFA500', '#FFFF00', '#FF8C00', '#DAA520']
    })

    // Additional bee confetti bursts
    setTimeout(() => {
      confetti({
        particleCount: 50,
        angle: 60,
        spread: 55,
        origin: { x: 0 },
        colors: ['#FFD700', '#FFA500', '#FFBF00']
      })
    }, 250)

    setTimeout(() => {
      confetti({
        particleCount: 50,
        angle: 120,
        spread: 55,
        origin: { x: 1 },
        colors: ['#FFD700', '#FFA500', '#FFBF00']
      })
    }, 400)

    // Special honey drip effect
    setTimeout(() => {
      confetti({
        particleCount: 30,
        spread: 360,
        ticks: 60,
        origin: { y: 0.3 },
        colors: ['#FFD700', '#FFBF00'],
        shapes: ['circle'],
        scalar: 0.8
      })
    }, 600)
  }

  updateStatusIndicator(status) {
    const statusIndicator = this.statusIndicatorTarget || document.querySelector('[data-rsvp-target="statusIndicator"]')
    
    if (!statusIndicator) return
    
    if (status === 'accepted') {
      statusIndicator.innerHTML = `
        <div class="flex items-center justify-center p-4 rounded-xl border-2 rsvp-status-indicator rsvp-status-accepted">
          <div class="flex items-center gap-2">
            <span class="text-2xl animate-bounce">🐝</span>
            <div class="text-center">
              <p class="font-bold text-sm sm:text-base" style="color: var(--bee-black);">¡Ya confirmaste tu vuelo al panal!</p>
              <p class="text-xs sm:text-sm" style="color: var(--bee-brown);">Tu asistencia está confirmada 🍯</p>
            </div>
            <span class="text-xl">✅</span>
          </div>
        </div>
      `
    } else if (status === 'declined') {
      statusIndicator.innerHTML = `
        <div class="flex items-center justify-center p-4 rounded-xl border-2 rsvp-status-indicator rsvp-status-declined">
          <div class="flex items-center gap-2">
            <span class="text-2xl">🍯</span>
            <div class="text-center">
              <p class="font-bold text-sm sm:text-base" style="color: var(--bee-brown);">Has declinado la invitación</p>
              <p class="text-xs sm:text-sm" style="color: var(--bee-brown);">Esperamos verte en la próxima floración</p>
            </div>
            <span class="text-xl">💔</span>
          </div>
        </div>
      `
    }
  }

  // Fallback templates in case partial loading fails
  getAcceptedTemplate() {
    return `
      <div class="bee-response-section">
        <div class="animate-bounce mb-4 sm:mb-6">
          <div class="bee-response-icon bee-response-success">🐝</div>
        </div>
        <h2 class="text-2xl sm:text-3xl font-bold mb-3 sm:mb-4 px-2" style="color: var(--bee-black);">¡Buzz Buzz! ¡Confirmado! 🍯</h2>
        <p class="text-base sm:text-lg mb-4 sm:mb-6 px-4" style="color: var(--bee-brown);">
          ¡Excelente! Como una abeja a la miel, esperamos verte en nuestro panal especial.
        </p>
        <div class="bee-alert bee-alert-success mx-2 sm:mx-0">
          <p class="text-sm sm:text-base">Te enviaremos más detalles dulces como la miel por correo electrónico pronto. 🌻</p>
        </div>
        <div class="text-xl sm:text-2xl mt-3 sm:mt-4">🐝 🌼 🍯 🌻 🐝</div>
      </div>
    `
  }

  getDeclinedTemplate() {
    return `
      <div class="bee-response-section">
        <div class="mb-4 sm:mb-6">
          <div class="bee-response-icon bee-response-declined">🍯</div>
        </div>
        <h2 class="text-2xl sm:text-3xl font-bold mb-3 sm:mb-4 px-2" style="color: var(--bee-brown);">Respuesta Registrada en el Panal</h2>
        <p class="text-base sm:text-lg mb-4 sm:mb-6 px-4" style="color: var(--bee-brown);">
          Lamentamos que no puedas volar hasta nuestro evento.
        </p>
        <div class="bee-alert bee-alert-warning mx-2 sm:mx-0">
          <p class="text-sm sm:text-base">¡Esperamos verte en la próxima floración! Siempre habrá un lugar en nuestro panal para ti. 🌻</p>
        </div>
        <div class="text-xl sm:text-2xl mt-3 sm:mt-4">🐝 💔 🌼</div>
      </div>
    `
  }
}
