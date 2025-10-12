import { Controller } from "@hotwired/stimulus"
import confetti from "canvas-confetti"

export default class extends Controller {
  static targets = ["acceptButton", "declineButton", "confirmationSection", "responseSection", "statusIndicator", "countdownTimer"]
  static values = { hashId: String, deadline: Number }

  connect() {
    console.log("RSVP controller connected")
    this.initializeCountdown()
  }

  disconnect() {
    if (this.countdownInterval) {
      clearInterval(this.countdownInterval)
    }
  }

  initializeCountdown() {
    if (this.hasDeadlineValue && this.hasCountdownTimerTarget) {
      this.updateCountdown()
      this.countdownInterval = setInterval(() => {
        this.updateCountdown()
      }, 1000)
    }
  }

  updateCountdown() {
    const now = Date.now()
    const timeLeft = this.deadlineValue - now
    
    if (timeLeft <= 0) {
      this.countdownTimerTarget.innerHTML = '⏰ ¡Tiempo agotado!'
      if (this.countdownInterval) {
        clearInterval(this.countdownInterval)
      }
      // Opcional: recargar la página para mostrar el estado "cerrado"
      setTimeout(() => {
        location.reload()
      }, 2000)
      return
    }
    
    const days = Math.floor(timeLeft / (1000 * 60 * 60 * 24))
    const hours = Math.floor((timeLeft % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))
    const minutes = Math.floor((timeLeft % (1000 * 60 * 60)) / (1000 * 60))
    const seconds = Math.floor((timeLeft % (1000 * 60)) / 1000)
    
    let countdownText = ''
    
    if (days > 0) {
      countdownText = `${days}d ${hours}h ${minutes}m ${seconds}s`
    } else if (hours > 0) {
      countdownText = `${hours}h ${minutes}m ${seconds}s`
    } else if (minutes > 0) {
      countdownText = `${minutes}m ${seconds}s`
    } else {
      countdownText = `${seconds}s`
    }
    
    this.countdownTimerTarget.innerHTML = `⏰ ${countdownText}`
  }

  async accept(event) {
    event.preventDefault()
    const response = await this.updateRSVP('accepted')
    if (response && response.success) {
      await this.showConfirmation('accepted')
      this.updateStatusIndicator('accepted')
      this.launchConfetti()
    }
  }

  async decline(event) {
    event.preventDefault()
    const response = await this.updateRSVP('declined')
    if (response && response.success) {
      await this.showConfirmation('declined')
      this.updateStatusIndicator('declined')
    }
  }

  async updateRSVP(status) {
    try {
      const requestBody = { 
        status: status, 
        hash_id: this.hashIdValue
      }

      const response = await fetch(`/invitations/${this.hashIdValue}/rsvp`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify(requestBody)
      })

      if (!response.ok) {
        throw new Error('Error updating RSVP')
      }

      const result = await response.json()
      return result
    } catch (error) {
      console.error('Error:', error)
      alert('Hubo un error al procesar tu respuesta. Por favor intenta de nuevo.')
      return null
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
    // Hippie-themed confetti with earthy colors
    confetti({
      particleCount: 100,
      spread: 70,
      origin: { y: 0.6 },
      colors: ['#90c695', '#d4a574', '#e6c994', '#c49a6c', '#7bb77f']
    })

    // Additional flower confetti bursts
    setTimeout(() => {
      confetti({
        particleCount: 50,
        angle: 60,
        spread: 55,
        origin: { x: 0 },
        colors: ['#90c695', '#d4a574', '#e6c994']
      })
    }, 250)

    setTimeout(() => {
      confetti({
        particleCount: 50,
        angle: 120,
        spread: 55,
        origin: { x: 1 },
        colors: ['#90c695', '#d4a574', '#e6c994']
      })
    }, 400)

    // Special flower rain effect
    setTimeout(() => {
      confetti({
        particleCount: 30,
        spread: 360,
        ticks: 60,
        origin: { y: 0.3 },
        colors: ['#90c695', '#d4a574'],
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
            <span class="text-2xl animate-bounce">🌻</span>
            <div class="text-center">
              <p class="font-bold text-sm sm:text-base" style="color: #8b4513;">¡Ya confirmaste tu asistencia al gathering!</p>
              <p class="text-xs sm:text-sm" style="color: #5d4e37;">Tu presencia está confirmada en armonía ✌️</p>
            </div>
            <span class="text-xl">✅</span>
          </div>
        </div>
      `
    } else if (status === 'declined') {
      statusIndicator.innerHTML = `
        <div class="flex items-center justify-center p-4 rounded-xl border-2 rsvp-status-indicator rsvp-status-declined">
          <div class="flex items-center gap-2">
            <span class="text-2xl">�</span>
            <div class="text-center">
              <p class="font-bold text-sm sm:text-base" style="color: #8b4513;">Has declinado la invitación</p>
              <p class="text-xs sm:text-sm" style="color: #5d4e37;">Esperamos verte en el futuro 💜</p>
            </div>
            <span class="text-xl">💔</span>
          </div>
        </div>
      `
    }
  }

  // Fallback templates with hippie theme
  getAcceptedTemplate() {
    return `
      <div class="hippie-response-section">
        <div class="animate-bounce mb-4 sm:mb-6">
          <div class="hippie-response-icon hippie-response-success">🌻</div>
        </div>
        <h2 class="text-2xl sm:text-3xl font-bold mb-3 sm:mb-4 px-2" style="color: #8b4513;">¡Peace & Love! ¡Confirmado! ✌️</h2>
        <p class="text-base sm:text-lg mb-4 sm:mb-6 px-4" style="color: #5d4e37;">
          ¡Excelente! Tu alma fluirá en armonía con nuestro gathering especial.
        </p>
        <div class="hippie-alert hippie-alert-success mx-2 sm:mx-0">
          <p class="text-sm sm:text-base">Te enviaremos más detalles cósmicos por correo electrónico pronto. 🌻</p>
        </div>
        <div class="text-xl sm:text-2xl mt-3 sm:mt-4">🌻 ✌️ � ☮️ 🦋</div>
      </div>
    `
  }

  getDeclinedTemplate() {
    return `
      <div class="hippie-response-section">
        <div class="mb-4 sm:mb-6">
          <div class="hippie-response-icon hippie-response-declined">�</div>
        </div>
        <h2 class="text-2xl sm:text-3xl font-bold mb-3 sm:mb-4 px-2" style="color: #8b4513;">Respuesta Registrada en el Universo</h2>
        <p class="text-base sm:text-lg mb-4 sm:mb-6 px-4" style="color: #5d4e37;">
          Lamentamos que no puedas fluir hasta nuestro gathering.
        </p>
        <div class="hippie-alert hippie-alert-warning mx-2 sm:mx-0">
          <p class="text-sm sm:text-base">¡Esperamos verte en la próxima vibración! Siempre habrá un lugar en nuestro círculo de amor para ti. 🌻</p>
        </div>
        <div class="text-xl sm:text-2xl mt-3 sm:mt-4">🌻 💔 ✌️</div>
      </div>
    `
  }
}
