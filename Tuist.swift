import ProjectDescription

let tuist = Tuist(
    plugins: [
        .local(path: .relativeToRoot("Plugins/DependencyPlugin")),
        .local(path: .relativeToRoot("Plugins/ConfigurationPlugin")),
        .local(path: .relativeToRoot("Plugins/EnvironmentPlugin")),
        .local(path: .relativeToRoot("Plugins/TemplatesPlugin"))
    ],
    generationOptions: .options()
)
