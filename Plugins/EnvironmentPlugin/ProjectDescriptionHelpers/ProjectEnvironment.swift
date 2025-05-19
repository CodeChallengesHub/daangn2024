import Foundation
import ProjectDescription

public struct ProjectEnvironment: Sendable {
    public let name: String
    public let bundleId: String
    public let organizationName: String
    public let deploymentTargets: DeploymentTargets
    public let destinations: Destinations
    public let baseSetting: SettingsDictionary
}

public let appEnvironment = ProjectEnvironment(
    name: "ITBook",
    bundleId: "com.tsleedev.itbook",
    organizationName: "https://github.com/tsleedev/",
    deploymentTargets: .iOS("14.0"),
    destinations: .iOS,
    baseSetting: [:]
)
