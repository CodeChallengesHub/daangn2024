import ProjectDescription

public extension ProjectDescription.Path {
    static var dev: Self {
        return .relativeToRoot("EnvironmentConfigs/Dev/Dev.xcconfig")
    }
    static var stage: Self {
        return .relativeToRoot("EnvironmentConfigs/Stage/Stage.xcconfig")
    }
    static var prod: Self {
        return .relativeToRoot("EnvironmentConfigs/Prod/Prod.xcconfig")
    }
    static var shared: Self {
        return .relativeToRoot("EnvironmentConfigs/_Shared/Shared.xcconfig")
    }
}
