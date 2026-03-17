import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "removeButton"]

  connect() {
    this.updateButton()
  }

  toggle() {
    this.updateButton()
  }

  updateButton() {
    const count = this.selectedCount
    const btn = this.removeButtonTarget
    btn.disabled = count === 0
    btn.style.opacity = count === 0 ? "0.4" : "1"
    btn.style.pointerEvents = count === 0 ? "none" : "auto"
  }

  confirmRemove(event) {
    const count = this.selectedCount
    if (count === 0) {
      event.preventDefault()
      return
    }
    if (!confirm(`Remove ${count} photo${count === 1 ? "" : "s"} from this gallery?`)) {
      event.preventDefault()
    }
  }

  get selectedCount() {
    return this.checkboxTargets.filter(cb => cb.checked).length
  }
}
