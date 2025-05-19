import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.Search.rawValue,
    targets: [
		.implements(module: .feature(.Search), product: .framework, dependencies: [
            .network(target: .TSNetwork),
        ])
	]
)
