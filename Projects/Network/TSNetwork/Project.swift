import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Network.TSNetwork.rawValue,
    targets: [
		.implements(module: .network(.TSNetwork), product: .framework, dependencies: [
            .aggregator(target: .Core),
        ])
	]
)
