import FocalPointController from "beautiful_photons/focal_point_controller"

export function registerControllers(application) {
  application.register("focal-point", FocalPointController)
}

export { FocalPointController }
