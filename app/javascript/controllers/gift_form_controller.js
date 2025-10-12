import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "nameField", "purchasedByField"]

  connect() {
    console.log("Gift form controller connected")
  }

  submitForm(event) {
    event.preventDefault()
    
    // Validaciones básicas antes de enviar
    if (!this.validateForm()) {
      return
    }

    // Deshabilitar el botón temporalmente para evitar envíos duplicados
    const submitButton = this.element.querySelector('input[type="submit"]')
    const originalText = submitButton.value
    
    submitButton.disabled = true
    submitButton.value = "Registrando regalo... 🎁"
    
    // Enviar el formulario
    this.element.submit()
    
    // Rehabilitar el botón después de un tiempo (por si hay errores)
    setTimeout(() => {
      submitButton.disabled = false
      submitButton.value = originalText
    }, 3000)
  }

  validateForm() {
    let isValid = true
    
    // Validar nombre del regalo
    if (this.nameFieldTarget.value.trim().length < 2) {
      this.showFieldError(this.nameFieldTarget, "El nombre del regalo debe tener al menos 2 caracteres")
      isValid = false
    } else {
      this.clearFieldError(this.nameFieldTarget)
    }
    
    // Validar nombre de quien compra
    if (this.purchasedByFieldTarget.value.trim().length < 2) {
      this.showFieldError(this.purchasedByFieldTarget, "Tu nombre debe tener al menos 2 caracteres")
      isValid = false
    } else {
      this.clearFieldError(this.purchasedByFieldTarget)
    }
    
    return isValid
  }

  showFieldError(field, message) {
    this.clearFieldError(field)
    
    field.classList.add('border-red-500', 'focus:ring-red-500', 'focus:border-red-500')
    field.classList.remove('border-gray-300', 'focus:ring-pink-500', 'focus:border-pink-500')
    
    const errorElement = document.createElement('p')
    errorElement.className = 'text-red-500 text-xs mt-1 field-error'
    errorElement.textContent = message
    
    field.parentNode.appendChild(errorElement)
  }

  clearFieldError(field) {
    field.classList.remove('border-red-500', 'focus:ring-red-500', 'focus:border-red-500')
    field.classList.add('border-gray-300', 'focus:ring-pink-500', 'focus:border-pink-500')
    
    const existingError = field.parentNode.querySelector('.field-error')
    if (existingError) {
      existingError.remove()
    }
  }

  // Limpiar errores al escribir
  clearErrorOnInput(event) {
    this.clearFieldError(event.target)
  }
}