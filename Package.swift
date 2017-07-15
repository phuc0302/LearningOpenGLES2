import PackageDescription


let package = Package(
    name: "FwiOpenGLES",
    targets: [
        Target(
            name: "FwiOpenGLES"
        )
    ],
    exclude: [
        "Tests/Resources"
    ]
)
