import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Aggregator.Core.rawValue,
    targets: [
        .implements(module: .aggregator(.Core), product: .framework, dependencies: [
            .core(target: .TSFoundationExtensions),
            .core(target: .TSLogger),
        ])
	]
)
