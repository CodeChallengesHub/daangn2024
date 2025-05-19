import ConfigurationPlugin
import DependencyPlugin
import EnvironmentPlugin
import ProjectDescription

// MARK: - Interface
public extension Target {
    static func interface(module: ModulePaths, dependencies: [TargetDependency] = []) -> Target {
        TargetSpec(sources: .interface, dependencies: dependencies)
            .toTarget(with: module.targetName(type: .interface), product: .framework)
    }
}

// MARK: - Implements
public extension Target {
    static func implements(
        module: ModulePaths,
        includeResources: Bool = false,
        product: Product = .staticLibrary,
        dependencies: [TargetDependency] = []
    ) -> Target {
        TargetSpec(
            sources: .sources,
            resources: includeResources ? ["Resources/**"] : nil,
            dependencies: dependencies
        )
        .toTarget(with: module.targetName(type: .sources), product: product)
    }
}

// MARK: - Testing
public extension Target {
    static func testing(module: ModulePaths, dependencies: [TargetDependency] = []) -> Target {
        TargetSpec(sources: .testing, dependencies: dependencies)
            .toTarget(with: module.targetName(type: .testing), product: .framework)
    }
}

// MARK: - Tests
public extension Target {
    static func tests(module: ModulePaths, dependencies: [TargetDependency] = []) -> Target {
        TargetSpec(sources: .unitTests, dependencies: dependencies)
            .toTarget(with: module.targetName(type: .unitTest), product: .unitTests)
    }
}

// MARK: - Example
public extension Target {
    static func example(module: ModulePaths, dependencies: [TargetDependency] = []) -> Target {
        TargetSpec(
            infoPlist: .extendingDefault(with: extendingDefault),
            sources: .exampleSources,
            resources: ["Example/Resources/**"],
            dependencies: dependencies + [.SPM.Inject],
            settings: .settings(
                base: ["OTHER_LDFLAGS": "$(inherited) -Xlinker -interposable"],
                configurations: []
            )
        )
        .toTarget(with: module.targetName(type: .example), product: .app)
    }
}

private let extendingDefault: [String : ProjectDescription.Plist.Value] = [
    "UILaunchStoryboardName": "LaunchScreen",
    "UIApplicationSceneManifest": [
        "UIApplicationSupportsMultipleScenes": false,
        "UISceneConfigurations": [
            "UIWindowSceneSessionRoleApplication": [
                [
                    "UISceneConfigurationName": "Default Configuration",
                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                ],
            ]
        ]
    ],
    "ENABLE_TESTS": .boolean(true)
]
