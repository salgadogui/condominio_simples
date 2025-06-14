import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "iframe", "loading"]

  connect() {
    console.log("PDF Modal controller connected")

    // Ensure modal is completely hidden on connect
    this.modalTarget.classList.add("hidden")
    this.modalTarget.style.display = "none"
    this.loadingTarget.classList.add("hidden")
    this.iframeTarget.classList.add("hidden")

    // Close modal when clicking outside
    this.boundCloseOnOutsideClick = this.closeOnOutsideClick.bind(this)

    // Close modal on escape key
    this.boundCloseOnEscape = this.closeOnEscape.bind(this)
  }

  disconnect() {
    document.removeEventListener("click", this.boundCloseOnOutsideClick)
    document.removeEventListener("keydown", this.boundCloseOnEscape)
  }

  open(event) {
    console.log("PDF Modal open called", event)
    event.preventDefault()

    const pdfUrl = event.currentTarget.href
    console.log("PDF URL:", pdfUrl)

    // Force modal positioning and display
    this.modalTarget.classList.remove("hidden")
    this.modalTarget.style.display = "flex"
    this.modalTarget.style.position = "fixed"
    this.modalTarget.style.top = "0"
    this.modalTarget.style.left = "0"
    this.modalTarget.style.right = "0"
    this.modalTarget.style.bottom = "0"
    this.modalTarget.style.zIndex = "9999"
    this.modalTarget.style.alignItems = "center"
    this.modalTarget.style.justifyContent = "center"

    // Find the modal content div and adjust its size
    const modalContent = this.modalTarget.querySelector('[data-action="click->pdf-modal#stopPropagation"]')
    if (modalContent) {
      // Calculate dimensions accounting for sidebar and topbar
      const viewportWidth = window.innerWidth
      const viewportHeight = window.innerHeight

      // Assume sidebar is about 250px and topbar is about 60px
      const sidebarWidth = 250
      const topbarHeight = 60

      // Calculate available space
      const availableWidth = viewportWidth - sidebarWidth - 32 // 32px for margins
      const availableHeight = viewportHeight - topbarHeight - 32 // 32px for margins

      // Set modal content size (use 90% of available space)
      modalContent.style.width = Math.min(availableWidth * 0.9, 1200) + 'px' // max 1200px
      modalContent.style.height = Math.min(availableHeight * 0.9, 800) + 'px' // max 800px
      modalContent.style.maxWidth = 'none'
      modalContent.style.maxHeight = 'none'
    }

    console.log("Modal styles applied:", this.modalTarget.style.cssText)

    document.body.classList.add("overflow-hidden")

    // Show loading state and hide iframe
    if (this.hasLoadingTarget) {
      this.loadingTarget.classList.remove("hidden")
      this.loadingTarget.style.display = "flex"
      console.log("Loading state shown")
    }

    if (this.hasIframeTarget) {
      this.iframeTarget.classList.add("hidden")
      this.iframeTarget.style.display = "none"
      this.iframeTarget.src = "" // Clear previous PDF
      console.log("Iframe hidden and cleared")
    }

    // Load PDF in iframe after a small delay to ensure loading state is visible
    setTimeout(() => {
      if (this.hasIframeTarget) {
        this.iframeTarget.src = pdfUrl
        console.log("PDF loading started")
      }
    }, 100)

    // Add event listeners
    setTimeout(() => {
      document.addEventListener("click", this.boundCloseOnOutsideClick)
      document.addEventListener("keydown", this.boundCloseOnEscape)
    }, 100)
  }

  close(event) {
    console.log("PDF Modal close called")
    if (event) {
      event.preventDefault()
    }

    this.modalTarget.classList.add("hidden")
    this.modalTarget.style.display = "none"
    document.body.classList.remove("overflow-hidden")
    this.iframeTarget.src = ""
    this.loadingTarget.classList.add("hidden")
    this.iframeTarget.classList.add("hidden")

    // Remove event listeners
    document.removeEventListener("click", this.boundCloseOnOutsideClick)
    document.removeEventListener("keydown", this.boundCloseOnEscape)
  }

  closeOnOutsideClick(event) {
    if (event.target === this.modalTarget) {
      this.close()
    }
  }

  closeOnEscape(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }

  onIframeLoad() {
    console.log("PDF loaded - hiding loading state")

    // Ensure loading is hidden and iframe is shown
    if (this.hasLoadingTarget) {
      this.loadingTarget.classList.add("hidden")
      this.loadingTarget.style.display = "none"
      console.log("Loading target hidden")
    }

    if (this.hasIframeTarget) {
      this.iframeTarget.classList.remove("hidden")
      this.iframeTarget.style.display = "block"
      console.log("Iframe target shown")
    }
  }

  // Prevent modal content clicks from closing modal
  stopPropagation(event) {
    event.stopPropagation()
  }
}