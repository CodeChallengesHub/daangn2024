// swift-tools-version: 6.0
@preconcurrency
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings
    import ProjectDescriptionHelpers

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: [:],
        baseSettings: .settings(
            configurations: [
                .debug(name: .dev),
                .debug(name: .stage),
                .release(name: .prod)
            ]
        )
    )
#endif

let package = Package(
    name: "TuistSampleApp",
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject.git", exact: "2.9.1"),
        
        .package(url: "https://github.com/krzysztofzablocki/Inject.git", from: "1.2.3"),
    ]
)
