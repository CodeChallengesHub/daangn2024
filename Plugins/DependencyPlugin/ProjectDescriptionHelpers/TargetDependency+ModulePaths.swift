import Foundation
import ProjectDescription

public extension TargetDependency {
    static func aggregator(target: ModulePaths.Aggregator) -> TargetDependency {
        .project(
            target: target.rawValue,
            path: .relativeToAggregator(target.rawValue)
        )
    }
    
    static func feature(
        target: ModulePaths.Feature,
        type: MicroTargetType = .sources
    ) -> TargetDependency {
        .project(
            target: target.targetName(type: type),
            path: .relativeToFeature(target.rawValue)
        )
    }

    static func service(
        target: ModulePaths.Service,
        type: MicroTargetType = .sources
    ) -> TargetDependency {
        .project(
            target: target.targetName(type: type),
            path: .relativeToService(target.rawValue)
        )
    }

    static func network(
        target: ModulePaths.Network,
        type: MicroTargetType = .sources
    ) -> TargetDependency {
        .project(
            target: target.targetName(type: type),
            path: .relativeToNetwork(target.rawValue)
        )
    }

    static func core(
        target: ModulePaths.Core,
        type: MicroTargetType = .sources
    ) -> TargetDependency {
        .project(
            target: target.targetName(type: type),
            path: .relativeToCore(target.rawValue)
        )
    }
    
    static func coreUI(
        target: ModulePaths.CoreUI,
        type: MicroTargetType = .sources
    ) -> TargetDependency {
        .project(
            target: target.targetName(type: type),
            path: .relativeToCoreUI(target.rawValue)
        )
    }

    static func thirdParty(
        target: ModulePaths.ThirdParty,
        type: MicroTargetType = .sources
    ) -> TargetDependency {
        .project(
            target: target.targetName(type: type),
            path: .relativeToThirdParty(target.rawValue)
        )
    }
}
