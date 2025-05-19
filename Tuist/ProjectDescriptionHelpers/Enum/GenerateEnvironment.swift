import ConfigurationPlugin
import Foundation
import ProjectDescription

/// 환경 설정 (CI/CD/DEV)
public enum GenerateEnvironment: String, Sendable {
    case ci = "CI"
    case cd = "CD"
    case dev = "DEV"

    /// 공통 스크립트 (일반 실행 스크립트)
    public var scripts: [TargetScript] {
        switch self {
        case .ci, .cd:
            return []
        case .dev:
            return [.swiftLint]
        }
    }

    /// 앱 관련 스크립트 (앱에서 실행해야 하는 것)
    public var appScripts: [TargetScript] {
        [.swiftLint, .copyGoogleServiceInfo, .firebaseCrashlytics]
    }
}

/// `ProcessInfo`에서 환경 변수 로드
public extension GenerateEnvironment {
    static var current: GenerateEnvironment {
        let environment = ProcessInfo.processInfo.environment["TUIST_ENV"] ?? "DEV"
        return GenerateEnvironment(rawValue: environment) ?? .dev
    }
}
