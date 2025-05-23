import ConfigurationPlugin
import EnvironmentPlugin
import ProjectDescription

public struct TargetSpec: Configurable {
    public var name: String
    public var destinations: Destinations
    public var product: Product
    public var productName: String?
    public var bundleId: String?
    public var deploymentTargets: DeploymentTargets?
    public var infoPlist: InfoPlist?
    public var sources: SourceFilesList?
    public var resources: ResourceFileElements?
    public var copyFiles: [CopyFilesAction]?
    public var headers: Headers?
    public var entitlements: Entitlements?
    public var scripts: [TargetScript]
    public var dependencies: [TargetDependency]
    public var settings: Settings?
    public var coreDataModels: [CoreDataModel]
    public var environment: [String : EnvironmentVariable]
    public var launchArguments: [LaunchArgument]
    public var additionalFiles: [FileElement]
    public var buildRules: [BuildRule]

    public init(
        name: String = "",
        destinations: Destinations = appEnvironment.destinations,
        product: Product = .staticLibrary,
        productName: String? = nil,
        bundleId: String? = nil,
        deploymentTargets: DeploymentTargets? = appEnvironment.deploymentTargets,
        infoPlist: InfoPlist = .default,
        sources: SourceFilesList? = .sources,
        resources: ResourceFileElements? = nil,
        copyFiles: [CopyFilesAction]? = nil,
        headers: Headers? = nil,
        entitlements: Entitlements? = nil,
        scripts: [TargetScript] = GenerateEnvironment.current.scripts,
        dependencies: [TargetDependency] = [],
        settings: Settings? = nil,
        coreDataModels: [CoreDataModel] = [],
        environment: [String: EnvironmentVariable] = [:],
        launchArguments: [LaunchArgument] = [],
        additionalFiles: [FileElement] = [],
        buildRules: [BuildRule] = []
    ) {
        self.name = name
        self.destinations = destinations
        self.product = product
        self.productName = productName
        self.bundleId = bundleId
        self.deploymentTargets = deploymentTargets
        self.infoPlist = infoPlist
        self.sources = sources
        self.resources = resources
        self.copyFiles = copyFiles
        self.headers = headers
        self.entitlements = entitlements
        self.scripts = scripts
        self.dependencies = dependencies
        self.settings = settings
        self.coreDataModels = coreDataModels
        self.environment = environment
        self.launchArguments = launchArguments
        self.additionalFiles = additionalFiles
        self.buildRules = buildRules
    }

    func toTarget() -> Target {
        self.toTarget(with: self.name)
    }

    func toTarget(with name: String, product: Product? = nil) -> Target {
        .target(
            name: name,
            destinations: destinations,
            product: product ?? self.product,
            productName: productName,
            bundleId: bundleId ?? "\(appEnvironment.bundleId).\(name)",
            deploymentTargets: deploymentTargets,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            copyFiles: copyFiles,
            headers: headers,
            entitlements: entitlements,
            scripts: scripts,
            dependencies: dependencies,
            settings: settings ?? .settings(
                base: appEnvironment.baseSetting.merging(
                    (product ?? self.product) == .framework ? .allLoadLDFlages : .ldFlages
                ),
                configurations: [],
                defaultSettings: .recommended
            ),
            coreDataModels: coreDataModels,
            environmentVariables: environment,
            launchArguments: launchArguments,
            additionalFiles: additionalFiles,
            buildRules: buildRules
        )
    }
}
