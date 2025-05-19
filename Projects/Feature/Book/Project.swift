import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.Book.rawValue,
    targets: [
		.implements(module: .feature(.Book), product: .framework, dependencies: [
            .aggregator(target: .Core),
            .aggregator(target: .CoreUI),
        ])
	]
)
