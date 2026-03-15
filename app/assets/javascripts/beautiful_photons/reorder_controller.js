import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item"]
  static values = { url: String }

  get photoIds() {
    return this.itemTargets.map((item) => item.dataset.photoId)
  }

  dragstart(event) {
    this.draggedItem = event.currentTarget
    event.dataTransfer.effectAllowed = "move"
  }

  dragover(event) {
    event.preventDefault()
    const target = event.currentTarget
    if (target === this.draggedItem) return

    const rect = target.getBoundingClientRect()
    const midY = rect.top + rect.height / 2

    if (event.clientY < midY) {
      target.parentNode.insertBefore(this.draggedItem, target)
    } else {
      target.parentNode.insertBefore(this.draggedItem, target.nextSibling)
    }
  }

  async drop(event) {
    event.preventDefault()
    await this.persist()
  }

  async persist() {
    await fetch(this.urlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ photo_ids: this.photoIds }),
    })
  }
}
