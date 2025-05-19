import Foundation
import ProjectDescription

// swiftlint: disable all
public enum ModulePaths {
    case aggregator(Aggregator)
    case feature(Feature)
    case service(Service)
    case network(Network)
    case core(Core)
    case coreUI(CoreUI)
    case thirdParty(ThirdParty)
}

public extension ModulePaths {
    func targetName(type: MicroTargetType) -> String {
        switch self {
        case let .aggregator(module as any MicroTargetPathConvertable),
            let .feature(module as any MicroTargetPathConvertable),
            let .service(module as any MicroTargetPathConvertable),
            let .network(module as any MicroTargetPathConvertable),
            let .core(module as any MicroTargetPathConvertable),
            let .coreUI(module as any MicroTargetPathConvertable),
            let .thirdParty(module as any MicroTargetPathConvertable):
            return module.targetName(type: type)
        }
    }
}

public extension ModulePaths {
    enum Aggregator: String, MicroTargetPathConvertable {
        case Core
        case CoreUI
    }
}

public extension ModulePaths {
    enum Feature: String, MicroTargetPathConvertable {
        case Book
        case Search
    }
}

public extension ModulePaths {
    enum Service: String, MicroTargetPathConvertable {
        case AnalyticsService
    }
}

public extension ModulePaths {
    enum Network: String, MicroTargetPathConvertable {
        case TSNetwork
    }
}

public extension ModulePaths {
    enum Core: String, MicroTargetPathConvertable {
        case TSFoundationExtensions
        case TSLogger
    }
}

public extension ModulePaths {
    enum CoreUI: String, MicroTargetPathConvertable {
        case TSImageCache
        case TSPreviewHelper
        case TSUIKitExtensions
    }
}

public extension ModulePaths {
    enum ThirdParty: String, MicroTargetPathConvertable {
        case FirebaseClient
    }
}

public enum MicroTargetType: String {
    case interface = "Interface"
    case sources = ""
    case testing = "Testing"
    case unitTest = "Tests"
    case example = "Example"
}

public protocol MicroTargetPathConvertable {
    func targetName(type: MicroTargetType) -> String
}

public extension MicroTargetPathConvertable where Self: RawRepresentable {
    func targetName(type: MicroTargetType) -> String {
        "\(self.rawValue)\(type.rawValue)"
    }
}

// MARK: - For DI
extension ModulePaths.Feature: CaseIterable {}
//extension ModulePaths.Service: CaseIterable {}
extension ModulePaths.Network: CaseIterable {}
