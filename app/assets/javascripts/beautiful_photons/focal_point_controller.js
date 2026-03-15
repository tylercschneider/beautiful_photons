import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image", "pin", "focalX", "focalY"]

  pick(event) {
    const rect = this.imageTarget.getBoundingClientRect()
    const x = ((event.clientX - rect.left) / rect.width * 100).toFixed(1)
    const y = ((event.clientY - rect.top) / rect.height * 100).toFixed(1)

    this.focalXTarget.value = x
    this.focalYTarget.value = y
    this.pinTarget.style.left = `${x}%`
    this.pinTarget.style.top = `${y}%`
  }
}
