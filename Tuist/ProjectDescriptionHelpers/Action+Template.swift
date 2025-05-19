import ProjectDescription

public extension TargetScript {
    static let swiftLint = TargetScript.pre(
        path: Path.relativeToRoot("Scripts/SwiftLintRunScript.sh"),
        name: "SwiftLint",
        basedOnDependencyAnalysis: false
    )
    
    static let copyGoogleServiceInfo = TargetScript.post(
        path: Path.relativeToRoot("Scripts/CopyGoogleServiceInfo.sh"),
        name: "Copy GoogleService-Info.plist",
        basedOnDependencyAnalysis: false
    )
    
    static let firebaseCrashlytics = TargetScript.post(
        script: "${SRCROOT}/../../Tuist/.build/checkouts/firebase-ios-sdk/Crashlytics/run",
        name: "Firebase Crashlytics",
        inputPaths: [
            "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${TARGET_NAME}",
            "$(SRCROOT)/$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)"
        ],
        basedOnDependencyAnalysis: false
    )
}
