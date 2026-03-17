import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image", "viewport", "cropX", "cropY", "cropZoom", "zoomSlider"]
  static values = { aspect: String }

  connect() {
    this.dragging = false
    this.dragStartX = 0
    this.dragStartY = 0
    this.startCropX = 0
    this.startCropY = 0
    this.viewportTarget.style.display = "block"
    this.updateViewport()
  }

  updateViewport() {
    const cropX = parseFloat(this.cropXTarget.value)
    const cropY = parseFloat(this.cropYTarget.value)
    const zoom = parseFloat(this.cropZoomTarget.value)

    // Viewport size is inverse of zoom — higher zoom = smaller viewport (tighter crop)
    const viewportPct = Math.min(100, 100 / zoom)
    const [aw, ah] = this.parseAspect()

    // Calculate viewport dimensions that fit the aspect ratio within the image
    const imgRect = this.imageTarget.getBoundingClientRect()
    const imgAspect = imgRect.width / imgRect.height
    const targetAspect = aw / ah

    let vpW, vpH
    if (targetAspect > imgAspect) {
      // Wider than image — constrain by width
      vpW = viewportPct
      vpH = viewportPct * (imgAspect / targetAspect)
    } else {
      // Taller than image — constrain by height
      vpH = viewportPct
      vpW = viewportPct * (targetAspect / imgAspect)
    }

    // Position: crop_x/crop_y is the center of the viewport as % of image
    const left = cropX - vpW / 2
    const top = cropY - vpH / 2

    const vp = this.viewportTarget
    vp.style.width = `${vpW}%`
    vp.style.height = `${vpH}%`
    vp.style.left = `${this.clamp(left, 0, 100 - vpW)}%`
    vp.style.top = `${this.clamp(top, 0, 100 - vpH)}%`

    if (this.hasZoomSliderTarget) {
      this.zoomSliderTarget.value = zoom
    }
  }

  startDrag(event) {
    event.preventDefault()
    this.dragging = true
    const touch = event.touches ? event.touches[0] : event
    this.dragStartX = touch.clientX
    this.dragStartY = touch.clientY
    this.startCropX = parseFloat(this.cropXTarget.value)
    this.startCropY = parseFloat(this.cropYTarget.value)

    const move = (e) => this.drag(e)
    const stop = () => {
      this.dragging = false
      document.removeEventListener("mousemove", move)
      document.removeEventListener("mouseup", stop)
      document.removeEventListener("touchmove", move)
      document.removeEventListener("touchend", stop)
    }

    document.addEventListener("mousemove", move)
    document.addEventListener("mouseup", stop)
    document.addEventListener("touchmove", move, { passive: false })
    document.addEventListener("touchend", stop)
  }

  drag(event) {
    if (!this.dragging) return
    event.preventDefault()

    const touch = event.touches ? event.touches[0] : event
    const imgRect = this.imageTarget.getBoundingClientRect()
    const dx = (touch.clientX - this.dragStartX) / imgRect.width * 100
    const dy = (touch.clientY - this.dragStartY) / imgRect.height * 100

    this.cropXTarget.value = this.clamp(this.startCropX + dx, 0, 100).toFixed(1)
    this.cropYTarget.value = this.clamp(this.startCropY + dy, 0, 100).toFixed(1)
    this.updateViewport()
  }

  sliderZoom(event) {
    this.cropZoomTarget.value = parseFloat(event.target.value).toFixed(2)
    this.updateViewport()
  }

  parseAspect() {
    const parts = (this.aspectValue || "1:1").split(":")
    return [parseFloat(parts[0]), parseFloat(parts[1])]
  }

  clamp(val, min, max) {
    return Math.max(min, Math.min(max, val))
  }
}
