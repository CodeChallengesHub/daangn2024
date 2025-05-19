import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.CoreUI.TSImageCache.rawValue,
    targets: [
		.implements(module: .coreUI(.TSImageCache), product: .framework)
	]
)
