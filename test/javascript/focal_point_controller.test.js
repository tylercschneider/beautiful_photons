import { describe, it, expect, beforeEach } from "vitest"
import { Application } from "@hotwired/stimulus"
import FocalPointController from "../../app/assets/javascripts/beautiful_photons/focal_point_controller.js"

describe("FocalPointController", () => {
  let application

  beforeEach(async () => {
    document.body.innerHTML = `
      <div data-controller="focal-point" style="position: relative;">
        <img src="test.jpg"
             style="width: 200px; height: 100px; display: block;"
             data-focal-point-target="image"
             data-action="click->focal-point#pick">
        <div data-focal-point-target="pin" style="left: 50%; top: 50%;"></div>
        <input type="hidden" data-focal-point-target="focalX" value="50">
        <input type="hidden" data-focal-point-target="focalY" value="50">
      </div>
    `

    application = Application.start()
    application.register("focal-point", FocalPointController)

    // Wait for Stimulus to connect the controller
    await new Promise((resolve) => setTimeout(resolve, 0))
  })

  it("updates focal point values on click", () => {
    const image = document.querySelector("[data-focal-point-target='image']")
    const focalX = document.querySelector("[data-focal-point-target='focalX']")
    const focalY = document.querySelector("[data-focal-point-target='focalY']")

    // Simulate getBoundingClientRect
    image.getBoundingClientRect = () => ({
      left: 0, top: 0, width: 200, height: 100, right: 200, bottom: 100
    })

    image.dispatchEvent(new MouseEvent("click", {
      clientX: 60,
      clientY: 25,
      bubbles: true,
    }))

    expect(focalX.value).toBe("30.0")
    expect(focalY.value).toBe("25.0")
  })

  it("moves the pin to the clicked position", () => {
    const image = document.querySelector("[data-focal-point-target='image']")
    const pin = document.querySelector("[data-focal-point-target='pin']")

    image.getBoundingClientRect = () => ({
      left: 0, top: 0, width: 200, height: 100, right: 200, bottom: 100
    })

    image.dispatchEvent(new MouseEvent("click", {
      clientX: 60,
      clientY: 25,
      bubbles: true,
    }))

    expect(parseFloat(pin.style.left)).toBeCloseTo(30.0)
    expect(parseFloat(pin.style.top)).toBeCloseTo(25.0)
  })
})
