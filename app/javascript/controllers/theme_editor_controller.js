import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "name", "primaryColor", "primaryColorText", "secondaryColor", "secondaryColorText",
    "contrastMode", "titleTemplate", "subtitleTemplate", "acceptText", "declineText",
    "acceptEmoji", "declineEmoji", "dateIcon", "locationIcon", "headerEmoji",
    "floatingElements", "preview"
  ]

  connect() {
    this.updatePreview()
    this.syncColorInputs()
  }

  updatePreview() {
    // Actualizar vista previa en tiempo real
    this.updatePreviewStyles()
    this.updatePreviewContent()
  }

  syncColorInputs() {
    // Sincronizar inputs de color y texto
    if (this.hasPrimaryColorTarget && this.hasPrimaryColorTextTarget) {
      this.primaryColorTarget.addEventListener('input', () => {
        this.primaryColorTextTarget.value = this.primaryColorTarget.value
        this.updatePreview()
      })
      
      this.primaryColorTextTarget.addEventListener('input', () => {
        if (this.isValidHexColor(this.primaryColorTextTarget.value)) {
          this.primaryColorTarget.value = this.primaryColorTextTarget.value
          this.updatePreview()
        }
      })
    }

    if (this.hasSecondaryColorTarget && this.hasSecondaryColorTextTarget) {
      this.secondaryColorTarget.addEventListener('input', () => {
        this.secondaryColorTextTarget.value = this.secondaryColorTarget.value
        this.updatePreview()
      })
      
      this.secondaryColorTextTarget.addEventListener('input', () => {
        if (this.isValidHexColor(this.secondaryColorTextTarget.value)) {
          this.secondaryColorTarget.value = this.secondaryColorTextTarget.value
          this.updatePreview()
        }
      })
    }
  }

  updatePreviewStyles() {
    if (!this.hasPreviewTarget) return

    const primaryColor = this.primaryColorTarget?.value || '#d4a574'
    const secondaryColor = this.secondaryColorTarget?.value || '#90c695'
    const contrastMode = this.contrastModeTarget?.value || 'dark'
    
    const textColor = contrastMode === 'dark' ? '#ffffff' : '#000000'
    const backgroundTextColor = contrastMode === 'dark' ? '#2d3748' : '#1a202c'
    const cardBackground = `rgba(255, 255, 255, ${contrastMode === 'dark' ? '0.9' : '0.95'})`

    // Actualizar CSS variables
    const previewContainer = this.previewTarget.querySelector('.preview-container')
    if (previewContainer) {
      previewContainer.style.setProperty('--theme-primary', primaryColor)
      previewContainer.style.setProperty('--theme-secondary', secondaryColor)
      previewContainer.style.setProperty('--theme-text', textColor)
      previewContainer.style.setProperty('--theme-bg-text', backgroundTextColor)
      previewContainer.style.setProperty('--theme-card-bg', cardBackground)

      // Actualizar gradiente de fondo
      const gradient = `linear-gradient(135deg, ${this.lightenColor(primaryColor, 0.8)} 0%, ${this.lightenColor(primaryColor, 0.6)} 50%, ${this.lightenColor(primaryColor, 0.4)} 100%)`
      previewContainer.style.background = gradient

      // Actualizar estilos específicos
      this.updatePreviewElementStyles(primaryColor, secondaryColor, textColor, backgroundTextColor, cardBackground)
    }
  }

  updatePreviewElementStyles(primaryColor, secondaryColor, textColor, backgroundTextColor, cardBackground) {
    const preview = this.previewTarget

    // Actualizar bordes de emojis del header
    const headerEmojiDivs = preview.querySelectorAll('.inline-block[style*="border-color"]')
    headerEmojiDivs.forEach((div, index) => {
      const borderColor = index % 2 === 0 ? primaryColor : secondaryColor
      div.style.borderColor = borderColor
    })

    // Actualizar títulos
    const titles = preview.querySelectorAll('h1, h2')
    titles.forEach(title => {
      title.style.color = backgroundTextColor
    })

    // Actualizar subtítulos
    const subtitles = preview.querySelectorAll('p[style*="color"]')
    subtitles.forEach(subtitle => {
      subtitle.style.color = backgroundTextColor
    })

    // Actualizar tarjeta principal
    const card = preview.querySelector('.bg-white')
    if (card) {
      card.style.background = cardBackground
    }

    // Actualizar botones
    const acceptButton = preview.querySelector('button[style*="background: linear-gradient"]')
    if (acceptButton) {
      acceptButton.style.background = `linear-gradient(135deg, ${primaryColor} 0%, ${secondaryColor} 100%)`
      acceptButton.style.color = textColor
    }

    const declineButton = preview.querySelector('button[style*="border-color"]')
    if (declineButton) {
      declineButton.style.borderColor = primaryColor
      declineButton.style.color = backgroundTextColor
    }

    // Actualizar cards de detalles
    const detailCards = preview.querySelectorAll('.flex.items-center.p-2')
    detailCards.forEach((card, index) => {
      const borderColor = index % 2 === 0 ? primaryColor : secondaryColor
      card.style.borderColor = borderColor
    })
  }

  updatePreviewContent() {
    if (!this.hasPreviewTarget) return

    // Actualizar emojis del header
    const headerEmoji = this.headerEmojiTarget?.value || '🌻,✌️,🌸'
    const emojis = headerEmoji.split(',').map(e => e.trim()).slice(0, 3)
    
    const headerEmojiElements = this.previewTarget.querySelectorAll('.inline-block .text-2xl')
    headerEmojiElements.forEach((element, index) => {
      if (emojis[index]) {
        element.textContent = emojis[index]
      }
    })

    // Actualizar título
    const titleTemplate = this.titleTemplateTarget?.value || '¡Te invitamos a nuestro {title}! 🌻✌️'
    const eventTitle = this.getEventTitle()
    const interpolatedTitle = titleTemplate.replace('{title}', eventTitle)
    
    const titleElement = this.previewTarget.querySelector('h1')
    if (titleElement) {
      titleElement.textContent = interpolatedTitle
    }

    // Actualizar subtítulo
    const subtitleTemplate = this.subtitleTemplateTarget?.value || 'Querida alma {name} 🌻'
    const interpolatedSubtitle = subtitleTemplate.replace('{name}', 'Usuario')
    
    const subtitleElement = this.previewTarget.querySelector('h1 + p')
    if (subtitleElement) {
      subtitleElement.textContent = interpolatedSubtitle
    }

    // Actualizar iconos
    const dateIcon = this.dateIconTarget?.value || '⏰'
    const locationIcon = this.locationIconTarget?.value || '🌍'
    
    const iconElements = this.previewTarget.querySelectorAll('.flex.items-center.p-2 .text-lg')
    if (iconElements[0]) iconElements[0].textContent = dateIcon
    if (iconElements[1]) iconElements[1].textContent = locationIcon

    // Actualizar textos de botones
    const acceptText = this.acceptTextTarget?.value || '¡Sí, me uno al gathering!'
    const declineText = this.declineTextTarget?.value || 'No podré ir esta vez'
    const acceptEmoji = this.acceptEmojiTarget?.value || '🌻'
    const declineEmoji = this.declineEmojiTarget?.value || '🌙'

    const buttonSpans = this.previewTarget.querySelectorAll('button span')
    if (buttonSpans.length >= 6) {
      buttonSpans[0].textContent = acceptEmoji  // Primer emoji del botón aceptar
      buttonSpans[1].textContent = acceptText   // Texto del botón aceptar
      buttonSpans[3].textContent = declineEmoji // Primer emoji del botón rechazar
      buttonSpans[4].textContent = declineText  // Texto del botón rechazar
    }
  }

  getEventTitle() {
    // Intentar obtener el título del evento desde algún lugar de la página
    const eventTitleElement = document.querySelector('[data-event-title]')
    if (eventTitleElement) {
      return eventTitleElement.dataset.eventTitle
    }
    
    // Fallback a un título genérico
    return 'Mi Evento'
  }

  isValidHexColor(color) {
    return /^#[0-9A-F]{6}$/i.test(color)
  }

  lightenColor(color, percent) {
    const num = parseInt(color.replace("#", ""), 16)
    const amt = Math.round(2.55 * percent * 100)
    const R = (num >> 16) + amt
    const G = (num >> 8 & 0x00FF) + amt
    const B = (num & 0x0000FF) + amt
    return "#" + (0x1000000 + (R < 255 ? R < 1 ? 0 : R : 255) * 0x10000 +
      (G < 255 ? G < 1 ? 0 : G : 255) * 0x100 +
      (B < 255 ? B < 1 ? 0 : B : 255)).toString(16).slice(1)
  }
}