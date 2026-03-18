import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "removeButton", "selectAllButton", "unselectAllButton", "modal", "modalMessage", "form"]
  static values = { message: { type: String, default: "Remove {count} from this gallery?" } }

  connect() {
    this.updateButton()
  }

  toggle() {
    this.updateButton()
  }

  selectAll() {
    this.checkboxTargets.forEach(cb => cb.checked = true)
    this.updateButton()
  }

  unselectAll() {
    this.checkboxTargets.forEach(cb => cb.checked = false)
    this.updateButton()
  }

  updateButton() {
    const count = this.selectedCount
    const total = this.checkboxTargets.length
    const btn = this.removeButtonTarget
    btn.disabled = count === 0
    btn.style.opacity = count === 0 ? "0.4" : "1"
    btn.style.pointerEvents = count === 0 ? "none" : "auto"

    if (this.hasSelectAllButtonTarget) {
      const allSelected = count === total
      this.selectAllButtonTarget.disabled = allSelected
      this.selectAllButtonTarget.style.opacity = allSelected ? "0.4" : "1"
      this.selectAllButtonTarget.style.pointerEvents = allSelected ? "none" : "auto"
    }

    if (this.hasUnselectAllButtonTarget) {
      const noneSelected = count === 0
      this.unselectAllButtonTarget.disabled = noneSelected
      this.unselectAllButtonTarget.style.opacity = noneSelected ? "0.4" : "1"
      this.unselectAllButtonTarget.style.pointerEvents = noneSelected ? "none" : "auto"
    }
  }

  showConfirm(event) {
    event.preventDefault()
    const count = this.selectedCount
    if (count === 0) return

    const label = `${count} photo${count === 1 ? "" : "s"}`
    this.modalMessageTarget.textContent = this.messageValue.replace("{count}", label)
    this.modalTarget.classList.remove("hidden")
  }

  confirmRemove() {
    this.modalTarget.classList.add("hidden")
    this.formTarget.requestSubmit()
  }

  cancelRemove() {
    this.modalTarget.classList.add("hidden")
  }

  closeOnBackdrop(event) {
    if (event.target === this.modalTarget) {
      this.cancelRemove()
    }
  }

  get selectedCount() {
    return this.checkboxTargets.filter(cb => cb.checked).length
  }
}
