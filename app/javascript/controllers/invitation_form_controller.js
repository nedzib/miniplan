import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="invitation-form"
export default class extends Controller {
  static targets = ["form", "nameInput", "emailInput", "phoneInput", "familyGroupSelect"]

  connect() {
    // Auto-limpiar el formulario si hay un mensaje de éxito al cargar la página
    this.checkForSuccessMessage()
  }

  // Método para limpiar el formulario
  clear() {
    // Limpiar campos de texto
    if (this.hasNameInputTarget) this.nameInputTarget.value = ""
    if (this.hasEmailInputTarget) this.emailInputTarget.value = ""
    if (this.hasPhoneInputTarget) this.phoneInputTarget.value = ""
    
    // Resetear el select de grupo familiar
    if (this.hasFamilyGroupSelectTarget) {
      this.familyGroupSelectTarget.selectedIndex = 0
    }
    
    // Enfocar el primer campo
    if (this.hasNameInputTarget) {
      this.nameInputTarget.focus()
    }
  }

  // Verificar si hay un mensaje de éxito y limpiar automáticamente
  checkForSuccessMessage() {
    const successMessage = document.querySelector('.bg-green-100')
    if (successMessage && successMessage.textContent.includes('successfully created')) {
      this.clear()
    }
  }

  // Método que se ejecuta cuando se envía el formulario
  submit(event) {
    // Permitir que el formulario se envíe normalmente
    // Después del redirect, el método connect() se ejecutará y limpiará el formulario si hay éxito
  }
}
