import ProjectDescription

private let layerAttribute = Template.Attribute.required("layer")
private let nameAttribute = Template.Attribute.required("name")
private let customFileNameAttribute = Template.Attribute.optional("custom-file-name", default: "Sources")
private let customTemplateAttribute = Template.Attribute.optional("custom-template", default: "Sources")

private let template = Template(
    description: "A template for a new module",
    attributes: [
        layerAttribute,
        nameAttribute,
        customFileNameAttribute,
        customTemplateAttribute
    ],
    items: [
        .file(
            path: "Projects/\(layerAttribute)/\(nameAttribute)/Sources/\(customFileNameAttribute).swift",
            templatePath: "\(customTemplateAttribute).stencil"
        )
    ]
)
