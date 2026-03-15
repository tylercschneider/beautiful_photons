import FocalPointController from "beautiful_photons/focal_point_controller"
import ReorderController from "beautiful_photons/reorder_controller"

export function registerControllers(application) {
  application.register("focal-point", FocalPointController)
  application.register("reorder", ReorderController)
}

export { FocalPointController, ReorderController }
