#!/usr/bin/swift
import Foundation

func handleSIGINT(_ signal: Int32) {
    exit(0)
}

signal(SIGINT, handleSIGINT)

enum LayerType: String, CaseIterable {
    case feature = "Feature"
    case service = "Service"
    case network = "Network"
    case core = "Core"
    case coreUI = "CoreUI"
    case thirdParty = "ThirdParty"
}

enum MicroTargetType: String {
    case interface = "Interface"
    case sources = ""
    case testing = "Testing"
    case unitTest = "Tests"
//    case uiTest = "UITests"
    case example = "Example"
}

let fileManager = FileManager.default
let currentPath = "./"
let bash = Bash()

func registerModuleDependency() {
    registerModulePaths()
    makeProjectDirectory()
//    registerXCConfig()

    let layerPrefix = layer.rawValue.prefix(1).lowercased() + layer.rawValue.dropFirst() // 첫 문자만 소문자로 변환
    let moduleEnum = ".\(layerPrefix)(.\(moduleName))"
    var targetString = "[\n"
    if hasInterface {
        makeScaffold(target: .interface)
        targetString += "\(tab(2)).interface(module: \(moduleEnum)),\n"
    }
    targetString += "\(tab(2)).implements(module: \(moduleEnum)"
    if hasInterface {
        targetString += ", dependencies: [\n\(tab(3)).\(layerPrefix)(target: .\(moduleName), type: .interface)\n\(tab(2))])"
    } else {
        targetString += ", product: .framework)"
    }
    if hasTesting {
        makeScaffold(target: .testing)
        let interfaceDependency = ".\(layerPrefix)(target: .\(moduleName), type: .interface)"
        targetString += ",\n\(tab(2)).testing(module: \(moduleEnum), dependencies: [\n\(tab(3))\(interfaceDependency)\n\(tab(2))])"
    }
    if hasUnitTests {
        makeScaffold(target: .unitTest)
        targetString += ",\n\(tab(2)).tests(module: \(moduleEnum), dependencies: [\n\(tab(3)).\(layerPrefix)(target: .\(moduleName))\n\(tab(2))])"
    }
//    if hasUITests {
//        makeScaffold(target: .uiTest)
//        #warning("ui test 타겟 설정 로직 추가")
//    }
    if hasExample {
        makeScaffold(target: .example)
        targetString += ",\n\(tab(2)).example(module: \(moduleEnum), dependencies: [\n\(tab(3)).\(layerPrefix)(target: .\(moduleName))\n\(tab(2))])"
    }
    targetString += "\n\(tab(1))]"
    makeProjectSwift(targetString: targetString)
    makeProjectScaffold()
}

func tab(_ count: Int) -> String {
    var tabString = ""
    for _ in 0..<count {
        tabString += "\t"
    }
    return tabString
}

func registerModulePaths() {
    updateFileContent(
        filePath: currentPath + "Plugins/DependencyPlugin/ProjectDescriptionHelpers/ModulePaths.swift",
        enumName: layer.rawValue,
        newCase: moduleName
    )
    print("Register \(moduleName) to ModulePaths.swift")
}

func registerXCConfig() {
    makeDirectory(path: currentPath + "XCConfig/\(moduleName)")
    let xcconfigContent = "#include \"../Shared.xcconfig\""
    for configuration in ["DEV", "STAGE", "PROD"] {
        writeContentInFile(
            path: currentPath + "XCConfig/\(moduleName)/\(configuration).xcconfig",
            content: xcconfigContent
        )
    }
}

func makeDirectory(path: String) {
    do {
        try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    } catch {
        fatalError("❌ failed to create directory: \(path)")
    }
}

func makeDirectories(_ paths: [String]) {
    paths.forEach(makeDirectory(path:))
}

func makeProjectSwift(targetString: String) {
    let projectSwift = """
import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.\(layer.rawValue).\(moduleName).rawValue,
    targets: \(targetString)
)

"""
    writeContentInFile(
        path: currentPath + "Projects/\(layer.rawValue)/\(moduleName)/Project.swift",
        content: projectSwift
    )
}

func makeProjectDirectory() {
    makeDirectory(path: currentPath + "Projects/\(layer.rawValue)/\(moduleName)")
}

func makeProjectScaffold() {
    var arguments: [String] = ["scaffold", "Feature", "--name", "\(moduleName)", "--layer", "\(layer.rawValue)"]
    
    // 조건에 따라 customFileName과 customTemplate 추가
    if layer.rawValue == "Feature" {
        arguments += [
            "--custom-file-name", "ViewController",
            "--custom-template", "ViewController"
        ]
    }
    
    // Tuist 명령 실행
    _ = try? bash.run(
        commandName: "tuist",
        arguments: arguments
    )
}

func makeScaffold(target: MicroTargetType) {
    _ = try? bash.run(
        commandName: "tuist",
        arguments: ["scaffold", "\(target.rawValue)", "--name", "\(moduleName)", "--layer", "\(layer.rawValue)"]
    )
}

func writeContentInFile(path: String, content: String) {
    let fileURL = URL(fileURLWithPath: path)
    let data = Data(content.utf8)
    try? data.write(to: fileURL)
}

func updateFileContent(
    filePath: String,
    enumName: String,  // 업데이트할 enum 이름 (예: "Core")
    newCase: String    // 추가할 case 이름 (예: "Logger")
) {
    let fileURL = URL(fileURLWithPath: filePath)

    // 파일 읽기
    guard let fileContent = try? String(contentsOf: fileURL, encoding: .utf8) else {
        fatalError("❌ Failed to read \(filePath)")
    }

    // `enum Core` 만 찾기 위한 정규식
    let enumPattern = "enum \(enumName): String, MicroTargetPathConvertable \\{([\\s\\S]*?)\\}"
    let regex = try! NSRegularExpression(pattern: enumPattern, options: [])
    guard let match = regex.firstMatch(in: fileContent, options: [], range: NSRange(fileContent.startIndex..., in: fileContent)),
          let enumRange = Range(match.range, in: fileContent) else {
        fatalError("❌ Could not find enum \(enumName) in \(filePath)")
    }

    // 해당 enum 내부 문자열만 추출
    let enumBlock = String(fileContent[enumRange])

    // 기존 case 목록 찾기
    let casePattern = "case (\\w+)"
    let caseRegex = try! NSRegularExpression(pattern: casePattern, options: [])
    let caseMatches = caseRegex.matches(in: enumBlock, options: [], range: NSRange(enumBlock.startIndex..., in: enumBlock))

    // 기존 case 목록 가져오기 (중복 방지)
    var caseList = Set(caseMatches.compactMap { match -> String? in
        guard let range = Range(match.range(at: 1), in: enumBlock) else { return nil }
        return String(enumBlock[range])
    })

    // 새로운 case 추가
    caseList.insert(newCase.trimmingCharacters(in: .whitespacesAndNewlines))

    // 알파벳 순 정렬
    let sortedCases = caseList.sorted().map { "        case \($0)" }.joined(separator: "\n")

    // 새로운 enum 블록 생성
    let newEnumBlock = "enum \(enumName): String, MicroTargetPathConvertable {\n\(sortedCases)\n    }"

    // 기존 enum 내용 교체
    let updatedContent = fileContent.replacingCharacters(in: enumRange, with: newEnumBlock)

    // 파일 덮어쓰기
    do {
        try updatedContent.write(to: fileURL, atomically: true, encoding: .utf8)
        print("✅ Updated \(enumName) in \(filePath) (sorted & deduplicated)")
    } catch {
        fatalError("❌ Failed to update \(filePath)")
    }
}

// MARK: - Starting point

// 사용 가능한 옵션을 자동으로 번호와 함께 출력
let availableLayers = LayerType.allCases.enumerated().map { "\($0 + 1). \($1.rawValue)" }.joined(separator: " | ")
print("Enter layer name or number\n(\(availableLayers))", terminator: " : ")

// 사용자 입력 받기
guard let input = readLine(), !input.isEmpty else {
    print("Layer is empty or invalid")
    exit(1)
}

let selectedLayer: LayerType?

if let number = Int(input), number > 0, number <= LayerType.allCases.count {
    // 숫자로 입력한 경우
    selectedLayer = LayerType.allCases[number - 1]
} else {
    // 문자열로 입력한 경우
    selectedLayer = LayerType(rawValue: input)
}

guard let finalLayer = selectedLayer else {
    print("Layer is empty or invalid")
    exit(1)
}

print("Selected Layer: \(finalLayer.rawValue)")
let layer = finalLayer

print("Enter module name", terminator: " : ")

var moduleName: String = ""

while true {
    let moduleInput = readLine()
    guard let moduleNameUnwrapping = moduleInput, !moduleNameUnwrapping.isEmpty else {
        print("Module name is empty. Please enter a valid name.", terminator: " : ")
        continue
    }

    let modulePath = "\(currentPath)Projects/\(layer.rawValue)/\(moduleNameUnwrapping)"

    // 폴더가 이미 존재하는지 확인
    if fileManager.fileExists(atPath: modulePath) {
        print("⚠️ Module '\(moduleNameUnwrapping)' already exists. Please enter a different name.", terminator: " : ")
    } else {
        moduleName = moduleNameUnwrapping
        print("Module name: \(moduleName)\n")
        break
    }
}

print("This module has a 'Interface' Target? (y\\n, default = n)", terminator: " : ")
let hasInterface = readLine()?.lowercased() == "y"

print("This module has a 'Testing' Target? (y\\n, default = n)", terminator: " : ")
let hasTesting = readLine()?.lowercased() == "y"

print("This module has a 'UnitTests' Target? (y\\n, default = n)", terminator: " : ")
let hasUnitTests = readLine()?.lowercased() == "y"

//print("This module has a 'UITests' Target? (y\\n, default = n)", terminator: " : ")
//let hasUITests = readLine()?.lowercased() == "y"

print("This module has a 'Example' Target? (y\\n, default = n)", terminator: " : ")
let hasExample = readLine()?.lowercased() == "y"

print("")

registerModuleDependency()

print("")
print("------------------------------------------------------------------------------------------------------------------------")
print("Layer: \(layer.rawValue)")
print("Module name: \(moduleName)")
//print("interface: \(hasInterface), testing: \(hasTesting), unitTests: \(hasUnitTests), uiTests: \(hasUITests), example: \(hasExample)")
print("interface: \(hasInterface), testing: \(hasTesting), unitTests: \(hasUnitTests), example: \(hasExample)")
print("------------------------------------------------------------------------------------------------------------------------")
print("✅ Module is created successfully!")

// MARK: - Bash
protocol CommandExecuting {
    func run(commandName: String, arguments: [String]) throws -> String
}

enum BashError: Error {
    case commandNotFound(name: String)
}

struct Bash: CommandExecuting {
    func run(commandName: String, arguments: [String] = []) throws -> String {
        return try run(resolve(commandName), with: arguments)
    }

    private func resolve(_ command: String) throws -> String {
        guard var bashCommand = try? run("/bin/bash", with: ["-l", "-c", "which \(command)"]) else {
            throw BashError.commandNotFound(name: command)
        }
        bashCommand = bashCommand.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        return bashCommand
    }

    private func run(_ command: String, with arguments: [String] = []) throws -> String {
        let process = Process()
        process.launchPath = command
        process.arguments = arguments
        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        process.launch()
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(decoding: outputData, as: UTF8.self)
        return output
    }
}
