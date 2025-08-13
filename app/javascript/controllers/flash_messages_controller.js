import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message", "closeButton"]

  connect() {
    // Auto-dismiss success messages after 5 seconds
    this.messageTargets.forEach((message) => {
      const flashType = message.dataset.flashType
      if (flashType === 'notice') {
        setTimeout(() => {
          this.dismissMessage(message)
        }, 5000)
      }
    })
  }

  dismiss(event) {
    const message = event.target.closest('.flash-message')
    this.dismissMessage(message)
  }

  dismissMessage(message) {
    // Add dismissing animation
    message.classList.add('translate-x-full', 'opacity-0')
    
    // Remove the element after animation completes
    setTimeout(() => {
      if (message.parentNode) {
        message.remove()
      }
      
      // Remove the entire flash container if no more messages
      if (this.messageTargets.length === 0) {
        this.element.remove()
      }
    }, 300)
  }
}
