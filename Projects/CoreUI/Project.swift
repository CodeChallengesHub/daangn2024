import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Aggregator.CoreUI.rawValue,
    targets: [
        .implements(module: .aggregator(.CoreUI), product: .framework, dependencies: [
            .coreUI(target: .TSImageCache),
            .coreUI(target: .TSPreviewHelper),
            .coreUI(target: .TSUIKitExtensions),
        ])
	]
)
