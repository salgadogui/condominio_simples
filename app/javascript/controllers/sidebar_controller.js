import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggleButton", "content"]

  connect() {
    console.log("Sidebar controller connected")
    console.log("Content target:", this.contentTarget)
  }

  toggle() {
    console.log("Toggle clicked")
    const sidebar = this.element
    const content = this.contentTarget

    console.log("Sidebar classes before:", sidebar.className)

    if (sidebar.classList.contains('w-64')) {
      // Collapse
      sidebar.classList.remove('w-64')
      sidebar.classList.add('w-12')
      sidebar.classList.add('sidebar-collapsed')
      sidebar.classList.remove('sidebar-expanded')

      // Fade out content first, then hide
      content.style.opacity = '0'
      setTimeout(() => {
        content.style.display = 'none'
      }, 200)

      this.toggleButtonTarget.textContent = '›'
      console.log("Collapsing - hiding content")
    } else {
      // Expand
      sidebar.classList.remove('w-12')
      sidebar.classList.add('w-64')
      sidebar.classList.add('sidebar-expanded')
      sidebar.classList.remove('sidebar-collapsed')

      // Show content first, then fade in
      content.style.display = 'block'
      setTimeout(() => {
        content.style.opacity = '1'
      }, 100)

      this.toggleButtonTarget.textContent = '‹'
      console.log("Expanding - showing content")
    }

    console.log("Sidebar classes after:", sidebar.className)
  }
}