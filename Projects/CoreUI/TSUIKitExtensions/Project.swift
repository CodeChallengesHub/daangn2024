import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.CoreUI.TSUIKitExtensions.rawValue,
    targets: [
		.implements(module: .coreUI(.TSUIKitExtensions), product: .framework)
	]
)
