import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener('click', this.confirmDelete.bind(this))
  }

  confirmDelete(event) {
    const confirmMessage = this.element.dataset.confirm
    
    if (confirmMessage) {
      // Create custom confirmation modal
      this.showConfirmModal(confirmMessage, () => {
        // If confirmed, proceed with the original action
        if (this.element.tagName === 'FORM') {
          // For button_to (form submission)
          this.element.submit()
        } else if (this.element.tagName === 'A') {
          // For link_to
          window.location.href = this.element.href
        } else if (this.element.form) {
          // For button inside form
          this.element.form.submit()
        }
      })
      
      // Prevent the default action
      event.preventDefault()
      return false
    }
  }

  showConfirmModal(message, onConfirm) {
    // Create modal backdrop
    const backdrop = document.createElement('div')
    backdrop.className = 'fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50'
    backdrop.innerHTML = `
      <div class="bg-white rounded-lg shadow-xl max-w-md w-full mx-4 p-6">
        <div class="flex items-center mb-4">
          <i class="nf nf-fa-exclamation_triangle text-red-600 text-2xl mr-3"></i>
          <h3 class="text-lg font-semibold text-gray-900">Confirm Deletion</h3>
        </div>
        <p class="text-gray-600 mb-6">${message}</p>
        <div class="flex justify-end space-x-3">
          <button class="cancel-btn px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition-colors duration-200">
            Cancel
          </button>
          <button class="confirm-btn px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors duration-200 flex items-center">
            <i class="nf nf-fa-trash mr-2"></i>
            Delete
          </button>
        </div>
      </div>
    `

    // Add event listeners
    const cancelBtn = backdrop.querySelector('.cancel-btn')
    const confirmBtn = backdrop.querySelector('.confirm-btn')

    cancelBtn.addEventListener('click', () => {
      document.body.removeChild(backdrop)
    })

    confirmBtn.addEventListener('click', () => {
      document.body.removeChild(backdrop)
      onConfirm()
    })

    // Close on backdrop click
    backdrop.addEventListener('click', (e) => {
      if (e.target === backdrop) {
        document.body.removeChild(backdrop)
      }
    })

    // Close on Escape key
    const handleEscape = (e) => {
      if (e.key === 'Escape') {
        document.body.removeChild(backdrop)
        document.removeEventListener('keydown', handleEscape)
      }
    }
    document.addEventListener('keydown', handleEscape)

    document.body.appendChild(backdrop)
  }
}
