import FocalPointController from "beautiful_photons/focal_point_controller"
import ReorderController from "beautiful_photons/reorder_controller"
import CropEditorController from "beautiful_photons/crop_editor_controller"

export function registerControllers(application) {
  application.register("focal-point", FocalPointController)
  application.register("reorder", ReorderController)
  application.register("crop-editor", CropEditorController)
}

export { FocalPointController, ReorderController, CropEditorController }
