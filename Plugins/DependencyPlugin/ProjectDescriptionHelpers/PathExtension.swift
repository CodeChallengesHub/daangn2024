import ProjectDescription

public extension ProjectDescription.Path {
    static func relativeToAggregator(_ path: String) -> Self {
        return .relativeToRoot("Projects/\(path)")
    }
    static func relativeToFeature(_ path: String) -> Self {
        return .relativeToRoot("Projects/Feature/\(path)")
    }
    static func relativeToService(_ path: String) -> Self {
        return .relativeToRoot("Projects/Service/\(path)")
    }
    static func relativeToNetwork(_ path: String) -> Self {
        return .relativeToRoot("Projects/Network/\(path)")
    }
    static func relativeToCore(_ path: String) -> Self {
        return .relativeToRoot("Projects/Core/\(path)")
    }
    static func relativeToCoreUI(_ path: String) -> Self {
        return .relativeToRoot("Projects/CoreUI/\(path)")
    }
    static func relativeToThirdParty(_ path: String) -> Self {
        return .relativeToRoot("Projects/ThirdParty/\(path)")
    }
    static var app: Self {
        return .relativeToRoot("Projects/App")
    }
}
