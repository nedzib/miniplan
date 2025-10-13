import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["memberCard", "acceptButton", "declineButton", "responseSection", "countdownTimer"]
  static values = { 
    hashId: String,
    updateUrl: String,
    deadline: Number
  }

  connect() {
    console.log("Family RSVP controller connected")
    this.initializeCountdown()
    this.setupButtons()
  }

  disconnect() {
    if (this.countdownInterval) {
      clearInterval(this.countdownInterval)
    }
  }

  setupButtons() {
    // Configurar los botones de aceptar/declinar con sus event listeners
    this.memberCardTargets.forEach(card => {
      const acceptBtn = card.querySelector('[data-family-rsvp-target="acceptButton"]')
      const declineBtn = card.querySelector('[data-family-rsvp-target="declineButton"]')
      
      if (acceptBtn) {
        acceptBtn.addEventListener('click', (e) => this.handleStatusUpdate(e, 'accepted'))
      }
      if (declineBtn) {
        declineBtn.addEventListener('click', (e) => this.handleStatusUpdate(e, 'declined'))
      }
    })
  }

  async handleStatusUpdate(event, status) {
    const button = event.currentTarget
    const memberId = button.dataset.memberId
    const memberCard = this.memberCardTargets.find(card => card.dataset.memberId === memberId)
    
    if (!memberCard) return

    // Deshabilitar botones temporalmente
    const buttons = memberCard.querySelectorAll('button[data-family-rsvp-target*="Button"]')
    this.disableButtons(buttons)
    
    try {
      const formData = new FormData()
      formData.append(`family_members[${memberId}][status]`, status)
      
      const response = await fetch(this.updateUrlValue, {
        method: 'PATCH',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: formData
      })
      
      const result = await response.json()
      
      if (result.success) {
        this.updateMemberCardVisual(memberCard, status)
        this.showNotification(`Confirmación actualizada con amor y paz 🌻`, 'success')
        this.launchHippieConfetti()
      } else {
        throw new Error(result.message || 'Error al procesar confirmación')
      }
    } catch (error) {
      console.error('Error:', error)
      this.showNotification('Hubo un problema con la confirmación. Intenta de nuevo 🌙', 'error')
    } finally {
      // Rehabilitar botones después de un segundo
      setTimeout(() => {
        this.enableButtons(buttons)
      }, 1000)
    }
  }

  updateMemberCardVisual(memberCard, status) {
    const statusIcon = memberCard.querySelector('.flex-shrink-0 span')
    const statusBadge = memberCard.querySelector('.status-badge')
    
    if (statusIcon) {
      statusIcon.textContent = status === 'accepted' ? '✌️' : '🌙'
    }
    
    if (statusBadge) {
      statusBadge.className = `status-badge status-${status}`
      statusBadge.textContent = status === 'accepted' ? '✌️ Confirmado' : '🌙 Declinado'
    }
    
    // Animación de confirmación
    memberCard.classList.add('updating')
    setTimeout(() => {
      memberCard.classList.remove('updating')
    }, 300)
  }

  disableButtons(buttons) {
    buttons.forEach(btn => {
      btn.disabled = true
      btn.style.opacity = '0.6'
    })
  }

  enableButtons(buttons) {
    buttons.forEach(btn => {
      btn.disabled = false
      btn.style.opacity = '1'
    })
  }

  launchHippieConfetti() {
    // Confetti hippie con colores earth
    if (typeof confetti !== 'undefined') {
      confetti({
        particleCount: 100,
        spread: 70,
        origin: { y: 0.6 },
        colors: ['#d4a574', '#90c695', '#e4a574', '#f5e6d3', '#e8d5b7']
      })

      setTimeout(() => {
        confetti({
          particleCount: 50,
          angle: 60,
          spread: 55,
          origin: { x: 0 },
          colors: ['#d4a574', '#90c695', '#e4a574']
        })
      }, 250)

      setTimeout(() => {
        confetti({
          particleCount: 50,
          angle: 120,
          spread: 55,
          origin: { x: 1 },
          colors: ['#90c695', '#e4a574', '#f5e6d3']
        })
      }, 400)
    }
  }

  copyInvitationLink(event) {
    const button = event.currentTarget
    const url = button.dataset.url
    const memberName = button.dataset.memberName
    
    navigator.clipboard.writeText(url).then(() => {
      this.showNotification(`Link personal de ${memberName} copiado con buenas vibras 🌻`, 'success')
    }).catch(() => {
      // Fallback para navegadores que no soportan clipboard API
      this.fallbackCopyToClipboard(url)
      this.showNotification(`Link personal de ${memberName} copiado 🌻`, 'success')
    })
  }

  fallbackCopyToClipboard(text) {
    const textArea = document.createElement('textarea')
    textArea.value = text
    document.body.appendChild(textArea)
    textArea.select()
    document.execCommand('copy')
    document.body.removeChild(textArea)
  }

  showNotification(message, type = 'success') {
    const notification = document.createElement('div')
    notification.className = `notification ${type}`
    
    const icon = type === 'success' ? '✌️' : '🌙'
    notification.innerHTML = `
      <span style="font-size: 1.125rem;">${icon}</span>
      <span>${message}</span>
    `
    
    document.body.appendChild(notification)
    
    setTimeout(() => {
      notification.remove()
    }, 4000)
  }

  initializeCountdown() {
    if (!this.hasCountdownTimerTarget || !this.deadlineValue) return
    
    const updateCountdown = () => {
      const now = Date.now()
      const timeLeft = this.deadlineValue - now
      
      if (timeLeft <= 0) {
        this.countdownTimerTarget.innerHTML = '⏰ ¡Tiempo agotado!'
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
    
    updateCountdown()
    this.countdownInterval = setInterval(updateCountdown, 1000)
  }
}