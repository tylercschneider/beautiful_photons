import { describe, it, expect, beforeEach, vi } from "vitest"
import { Application } from "@hotwired/stimulus"
import ReorderController from "../../app/assets/javascripts/beautiful_photons/reorder_controller.js"

describe("ReorderController", () => {
  let application

  beforeEach(async () => {
    document.body.innerHTML = `
      <div data-controller="reorder" data-reorder-url-value="/admin/galleries/1/reorder">
        <div data-reorder-target="item" data-photo-id="10" draggable="true">Photo A</div>
        <div data-reorder-target="item" data-photo-id="20" draggable="true">Photo B</div>
        <div data-reorder-target="item" data-photo-id="30" draggable="true">Photo C</div>
      </div>
    `

    application = Application.start()
    application.register("reorder", ReorderController)
    await new Promise((resolve) => setTimeout(resolve, 0))
  })

  it("collects photo IDs in DOM order", () => {
    const controller = application.getControllerForElementAndIdentifier(
      document.querySelector("[data-controller='reorder']"),
      "reorder"
    )

    expect(controller.photoIds).toEqual(["10", "20", "30"])
  })

  it("sends reorder request after drop", async () => {
    global.fetch = vi.fn(() => Promise.resolve({ ok: true }))

    const items = document.querySelectorAll("[data-reorder-target='item']")
    const container = document.querySelector("[data-controller='reorder']")

    // Simulate drag: move item C (30) before item A (10)
    container.insertBefore(items[2], items[0])

    // Trigger the drop action
    const controller = application.getControllerForElementAndIdentifier(container, "reorder")
    await controller.persist()

    expect(global.fetch).toHaveBeenCalledWith(
      "/admin/galleries/1/reorder",
      expect.objectContaining({
        method: "PATCH",
        headers: expect.objectContaining({ "Content-Type": "application/json" }),
        body: JSON.stringify({ photo_ids: ["30", "10", "20"] }),
      })
    )
  })
})
