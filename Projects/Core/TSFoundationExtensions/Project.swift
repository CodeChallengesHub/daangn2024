import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Core.TSFoundationExtensions.rawValue,
    targets: [
        .implements(module: .core(.TSFoundationExtensions), product: .framework, dependencies: [
            
        ])
	]
)
