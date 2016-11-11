import PackageDescription

let package = Package(
    name: "FoodTruckBot",
    dependencies: [
        .Package(url: "https://github.com/TensaiSolutions/SlackKit-Vapor.git", majorVersion: 4)
        
    ],
    exclude: [
        "Images"
    ]
)
