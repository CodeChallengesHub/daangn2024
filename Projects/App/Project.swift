import ConfigurationPlugin
import DependencyPlugin
import EnvironmentPlugin
import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Project
let project = Project(
    name: appEnvironment.name,
    organizationName: appEnvironment.organizationName,
    options: .options(automaticSchemesOptions: .disabled),
    settings: .settings(
        base: appEnvironment.baseSetting,
        configurations: .projectConfigurations,
        defaultSettings: .recommended
    ),
    targets: targets,
    schemes: schemes
)

// MARK: - Targets
var targets: [Target] {
    [
        .target(
            name: appEnvironment.name,
            destinations: appEnvironment.destinations,
            product: .app,
            bundleId: appEnvironment.bundleId,
            deploymentTargets: appEnvironment.deploymentTargets,
            infoPlist: .file(path: "Configuration/Info.plist"),
            sources: appSources,
            resources: appResources,
//            entitlements: "Configuration/TuistSampleApp.entitlements",
            scripts: GenerateEnvironment.current.appScripts,
            dependencies: appDependencies,
            settings: appSettings,
            additionalFiles: appAdditionalFiles
        )
    ]
}

// MARK: - Schemes
var schemes: [Scheme] {
    [
        .scheme(
            name: "\(appEnvironment.name)-DEV",
            shared: true,
            buildAction: .buildAction(targets: ["\(appEnvironment.name)"]),
            runAction: .runAction(configuration: .dev),
            archiveAction: .archiveAction(configuration: .dev),
            profileAction: .profileAction(configuration: .dev),
            analyzeAction: .analyzeAction(configuration: .dev)
        ),
        .scheme(
            name: "\(appEnvironment.name)-STAGE",
            shared: true,
            buildAction: .buildAction(targets: ["\(appEnvironment.name)"]),
            runAction: .runAction(configuration: .stage),
            archiveAction: .archiveAction(configuration: .stage),
            profileAction: .profileAction(configuration: .stage),
            analyzeAction: .analyzeAction(configuration: .stage)
        ),
        .scheme(
            name: "\(appEnvironment.name)-PROD",
            shared: true,
            buildAction: .buildAction(targets: ["\(appEnvironment.name)"]),
            runAction: .runAction(configuration: .prod),
            archiveAction: .archiveAction(configuration: .prod),
            profileAction: .profileAction(configuration: .prod),
            analyzeAction: .analyzeAction(configuration: .prod)
        )
    ]
}

// MARK: - Sources
var appSources: SourceFilesList? {
    [
        .glob("Sources/**"),
    ]
}

// MARK: - Resources
var appResources: ResourceFileElements {
    [
        .glob(pattern: "Resources/**")
    ]
}

// MARK: - Dependencies
var appDependencies: [TargetDependency] {
    var dependencies: [TargetDependency] = []
    dependencies += ModulePaths.Feature.allCases.map { TargetDependency.feature(target: $0) }
//    dependencies += ModulePaths.Service.allCases.map { TargetDependency.service(target: $0) }
    dependencies += ModulePaths.Network.allCases.map { TargetDependency.network(target: $0) }
    dependencies += [
//        .service(target: .AnalyticsService),
        .SPM.Swinject,
    ]
    return dependencies
}

// MARK: - Settings
var appConfigurations: [Configuration] {
    [
        .debug(name: .dev, xcconfig: .dev),
        .debug(name: .stage, xcconfig: .stage),
        .release(name: .prod, xcconfig: .prod)
    ]
}

var appSettings: Settings {
    .settings(
        base: [:],
        configurations: appConfigurations,
        defaultSettings: .recommended
    )
}

// MARK: - AdditionalFiles
var appAdditionalFiles: [FileElement] {
    [
        .glob(pattern: .relativeToRoot("Scripts")),
    ]
}
