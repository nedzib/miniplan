import { Controller } from "@hotwired/stimulus"
import confetti from "canvas-confetti"

export default class extends Controller {
  static targets = ["form", "submitButton", "responseSection", "statusRadio"]
  static values = { hashId: String }

  connect() {
    console.log("Family RSVP controller connected")
    this.setupRadioButtons()
  }

  setupRadioButtons() {
    // Agregar estilos dinámicos a los radio buttons
    this.statusRadioTargets.forEach(radio => {
      radio.addEventListener('change', this.handleRadioChange.bind(this))
      this.updateRadioStyle(radio)
    })
  }

  handleRadioChange(event) {
    const radio = event.target
    const memberId = this.extractMemberId(radio.name)
    const memberCard = radio.closest('.p-4.rounded-lg')
    
    // Actualizar estilos de todos los radios del mismo miembro
    const memberRadios = memberCard.querySelectorAll('input[type="radio"]')
    memberRadios.forEach(r => this.updateRadioStyle(r))
    
    // Mostrar feedback visual
    this.showMemberFeedback(memberCard, radio.value)
  }

  updateRadioStyle(radio) {
    const label = radio.closest('label')
    if (!label) return
    
    if (radio.checked) {
      label.style.opacity = '1'
      label.style.transform = 'scale(1.05)'
      label.style.boxShadow = '0 4px 15px rgba(0, 0, 0, 0.2)'
    } else {
      label.style.opacity = '0.7'
      label.style.transform = 'scale(1)'
      label.style.boxShadow = '0 2px 5px rgba(0, 0, 0, 0.1)'
    }
  }

  showMemberFeedback(memberCard, status) {
    const statusIcon = memberCard.querySelector('.mr-3 span')
    if (statusIcon) {
      if (status === 'accepted') {
        statusIcon.textContent = '✅'
      } else if (status === 'declined') {
        statusIcon.textContent = '❌'
      }
    }
    
    // Agregar una animación temporal
    memberCard.style.transform = 'scale(1.02)'
    memberCard.style.transition = 'transform 0.2s ease'
    
    setTimeout(() => {
      memberCard.style.transform = 'scale(1)'
    }, 200)
  }

  extractMemberId(inputName) {
    const match = inputName.match(/family_members\[(\d+)\]/)
    return match ? match[1] : null
  }

  async submitForm(event) {
    event.preventDefault()
    
    this.submitButtonTarget.disabled = true
    this.submitButtonTarget.innerHTML = `
      <span class="bee-icon text-xl">⏳</span>
      <span class="flex-1">Procesando confirmaciones...</span>
      <span class="bee-icon text-xl">🐝</span>
    `
    
    try {
      const formData = new FormData(this.formTarget)
      const response = await fetch(this.formTarget.action, {
        method: 'PATCH',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: formData
      })
      
      const result = await response.json()
      
      if (result.success) {
        await this.showSuccessResponse(result.message)
        this.launchConfetti()
        
        // Actualizar estados visuales
        this.updateMemberStates()
      } else {
        throw new Error(result.message || 'Error al procesar confirmaciones')
      }
    } catch (error) {
      console.error('Error:', error)
      this.showErrorResponse(error.message)
    } finally {
      this.resetSubmitButton()
    }
  }

  updateMemberStates() {
    // Actualizar los estados de "Estado actual" basado en las selecciones
    this.statusRadioTargets.forEach(radio => {
      if (radio.checked) {
        const memberCard = radio.closest('.p-4.rounded-lg')
        const statusText = memberCard.querySelector('p:nth-child(2) span.font-medium')
        
        if (statusText) {
          const newStatus = radio.value === 'accepted' ? 'Confirmado' : 'Declinado'
          statusText.textContent = newStatus
        }
      }
    })
  }

  async showSuccessResponse(message) {
    this.responseSectionTarget.innerHTML = `
      <div class="bee-response-section">
        <div class="animate-bounce mb-4 sm:mb-6">
          <div class="bee-response-icon bee-response-success">🐝</div>
        </div>
        <h2 class="text-2xl sm:text-3xl font-bold mb-3 sm:mb-4 px-2" style="color: var(--bee-black);">¡Confirmaciones Actualizadas! 🍯</h2>
        <p class="text-base sm:text-lg mb-4 sm:mb-6 px-4" style="color: var(--bee-brown);">
          ${message || '¡Excelente! Todas las confirmaciones familiares han sido actualizadas exitosamente.'}
        </p>
        <div class="bee-alert bee-alert-success mx-2 sm:mx-0">
          <p class="text-sm sm:text-base">Los miembros confirmados recibirán más detalles por correo electrónico. 🌻</p>
        </div>
        <div class="text-xl sm:text-2xl mt-3 sm:mt-4">🐝 👨‍👩‍👧‍👦 🍯 👨‍👩‍👧‍👦 🐝</div>
      </div>
    `
    this.responseSectionTarget.classList.remove('hidden')
  }

  showErrorResponse(message) {
    this.responseSectionTarget.innerHTML = `
      <div class="bee-response-section">
        <div class="mb-4 sm:mb-6">
          <div class="bee-response-icon bee-response-error">❌</div>
        </div>
        <h2 class="text-2xl sm:text-3xl font-bold mb-3 sm:mb-4 px-2" style="color: var(--bee-brown);">Error en las Confirmaciones</h2>
        <p class="text-base sm:text-lg mb-4 sm:mb-6 px-4" style="color: var(--bee-brown);">
          ${message || 'Hubo un problema al procesar las confirmaciones.'}
        </p>
        <div class="bee-alert bee-alert-error mx-2 sm:mx-0">
          <p class="text-sm sm:text-base">Por favor, intenta de nuevo o contacta con los organizadores. 🐝</p>
        </div>
      </div>
    `
    this.responseSectionTarget.classList.remove('hidden')
  }

  resetSubmitButton() {
    setTimeout(() => {
      this.submitButtonTarget.disabled = false
      this.submitButtonTarget.innerHTML = `
        <span class="bee-icon text-xl">🌸</span>
        <span class="flex-1">Confirmar Asistencias del Grupo</span>
        <span class="bee-icon text-xl">🐝</span>
      `
    }, 2000)
  }

  launchConfetti() {
    // Family-themed confetti with warm colors
    confetti({
      particleCount: 120,
      spread: 70,
      origin: { y: 0.6 },
      colors: ['#FFD700', '#FFA500', '#FF69B4', '#9370DB', '#32CD32']
    })

    // Additional family celebration bursts
    setTimeout(() => {
      confetti({
        particleCount: 60,
        angle: 60,
        spread: 55,
        origin: { x: 0 },
        colors: ['#FFD700', '#FFA500', '#FF69B4']
      })
    }, 250)

    setTimeout(() => {
      confetti({
        particleCount: 60,
        angle: 120,
        spread: 55,
        origin: { x: 1 },
        colors: ['#9370DB', '#32CD32', '#FFD700']
      })
    }, 400)

    // Heart burst for family love
    setTimeout(() => {
      confetti({
        particleCount: 40,
        spread: 360,
        ticks: 60,
        origin: { y: 0.3 },
        colors: ['#FF69B4', '#FFB6C1', '#FFC0CB'],
        shapes: ['circle'],
        scalar: 1.2
      })
    }, 600)
  }
}