import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["startTime", "endTime", "submitButton"]

  connect() {
    this.updateEndTime()
  }

  updateEndTime() {
    if (this.hasStartTimeTarget && this.hasEndTimeTarget) {
      const startTime = new Date(this.startTimeTarget.value)
      
      if (startTime && !this.endTimeTarget.value) {
        // Set default end time to 2 hours after start time
        const endTime = new Date(startTime.getTime() + (2 * 60 * 60 * 1000))
        this.endTimeTarget.value = this.formatDateTimeLocal(endTime)
      }
    }
  }

  formatDateTimeLocal(date) {
    const year = date.getFullYear()
    const month = String(date.getMonth() + 1).padStart(2, '0')
    const day = String(date.getDate()).padStart(2, '0')
    const hours = String(date.getHours()).padStart(2, '0')
    const minutes = String(date.getMinutes()).padStart(2, '0')
    
    return `${year}-${month}-${day}T${hours}:${minutes}`
  }

  validateForm(event) {
    const startTime = new Date(this.startTimeTarget.value)
    const endTime = new Date(this.endTimeTarget.value)
    
    if (endTime && startTime && endTime <= startTime) {
      event.preventDefault()
      this.showError("End time must be after start time")
      return false
    }
    
    return true
  }

  showError(message) {
    // Create or update error message
    let errorDiv = this.element.querySelector('.stimulus-error')
    
    if (!errorDiv) {
      errorDiv = document.createElement('div')
      errorDiv.className = 'stimulus-error bg-red-50 border border-red-200 rounded-lg p-4 mb-6'
      errorDiv.innerHTML = `
        <div class="flex items-center">
          <i class="nf nf-fa-exclamation_triangle text-red-600 mr-2"></i>
          <span class="text-red-800 font-semibold">Error:</span>
          <span class="text-red-700 ml-2"></span>
        </div>
      `
      this.element.prepend(errorDiv)
    }
    
    const messageSpan = errorDiv.querySelector('span:last-child')
    messageSpan.textContent = message
    
    // Auto-hide after 5 seconds
    setTimeout(() => {
      if (errorDiv.parentNode) {
        errorDiv.remove()
      }
    }, 5000)
  }
}
