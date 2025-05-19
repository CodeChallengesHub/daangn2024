import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.CoreUI.TSPreviewHelper.rawValue,
    targets: [
		.implements(module: .coreUI(.TSPreviewHelper), product: .framework)
	]
)
