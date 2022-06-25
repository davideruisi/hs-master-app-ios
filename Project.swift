import ProjectDescription

let project = Project(
    name: "HSMaster",
    organizationName: "davideruisi",
    options: .options(
        textSettings: .textSettings(
            usesTabs: false,
            indentWidth: 2
        )
    ),
    targets: [
        Target(
            name: "HSMaster",
            platform: .iOS,
            product: .app,
            bundleId: "com.davideruisi.HSMaster",
            deploymentTarget: .iOS(targetVersion: "14.0", devices: [.iphone, .ipad]),
            infoPlist: .extendingDefault(with: [
                "CFBundleShortVersionString": "1.1",
                "CFBundleVersion": "4",
                "LSRequiresIPhoneOS": true,
                "UIApplicationSupportsIndirectInputEvents": true,
                "UILaunchStoryboardName": "LaunchScreen",
                "UIRequiredDeviceCapabilities": ["armv7"],
                "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
                "UIRequiresFullScreen": true,
                "CONTENTFUL_SPACE_ID": "$(CONTENTFUL_SPACE_ID)",
                "CONTENTFUL_ACCESS_TOKEN": "$(CONTENTFUL_ACCESS_TOKEN)",
                "BATTLE_NET_CLIENT_ID": "$(BATTLE_NET_CLIENT_ID)",
                "BATTLE_NET_CLIENT_SECRET": "$(BATTLE_NET_CLIENT_SECRET)",
                "KEYCHAIN_SERVICE_ACCESS_TOKEN": "$(KEYCHAIN_SERVICE_ACCESS_TOKEN)",
                "KEYCHAIN_ACCOUNT_BATTLE_NET": "$(KEYCHAIN_ACCOUNT_BATTLE_NET)"
            ]),
            sources: ["HSMaster/Sources/**"],
            resources: ["HSMaster/Resources/**"],
            scripts: [
                .pre(
                    script: """
                      if which "${PODS_ROOT}/SwiftLint/swiftlint" >/dev/null; then
                        ${PODS_ROOT}/SwiftLint/swiftlint --fix && ${PODS_ROOT}/SwiftLint/swiftlint
                      else
                        echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
                      fi
                    """,
                    name: "SwiftLint"
                )
            ],
            settings: .settings(configurations: [
                .debug(name: .debug, xcconfig: .relativeToRoot("HSMaster/Resources/Configs/Debug.xcconfig")),
                .release(name: .release, xcconfig: .relativeToRoot("HSMaster/Resources/Configs/Release.xcconfig"))
            ])
        )
    ]
)
