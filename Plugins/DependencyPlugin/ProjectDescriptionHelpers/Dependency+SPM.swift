import ProjectDescription

public extension TargetDependency {
    struct SPM {}
}

public extension TargetDependency.SPM {
    static let FirebaseAnalytics = TargetDependency.external(name: "FirebaseAnalytics")
    static let FirebaseCrashlytics = TargetDependency.external(name: "FirebaseCrashlytics")
    static let Inject = TargetDependency.external(name: "Inject")
    static let SnapKit = TargetDependency.external(name: "SnapKit")
    static let Swinject = TargetDependency.external(name: "Swinject")
    static let Then = TargetDependency.external(name: "Then")
}

public extension Package {
}
