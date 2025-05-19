import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Core.TSLogger.rawValue,
    targets: [
        .implements(module: .core(.TSLogger), product: .framework, dependencies: [
            
        ])
	]
)
