import Combine
import Foundation

enum AppLanguage: String, CaseIterable, Codable, Identifiable {
    case system
    case english
    case simplifiedChinese

    var id: String { rawValue }
}

@MainActor
final class AppLanguageStore: ObservableObject {
    static let storageKey = "app.language.v1"
    static let nativeMenuLanguagesKey = "AppleLanguages"

    @Published var selection: AppLanguage {
        didSet {
            defaults.set(selection.rawValue, forKey: Self.storageKey)
            synchronizeNativeMenuLanguage()
        }
    }

    private let defaults: UserDefaults
    private let systemLocale: Locale

    init(
        defaults: UserDefaults = .standard,
        systemLocale: Locale = .current,
        initial: AppLanguage? = nil
    ) {
        self.defaults = defaults
        self.systemLocale = systemLocale
        let saved = defaults.string(forKey: Self.storageKey).flatMap(AppLanguage.init(rawValue:))
        selection = initial ?? saved ?? .system
        synchronizeNativeMenuLanguage()
    }

    private func synchronizeNativeMenuLanguage() {
        switch selection {
        case .english:
            defaults.set(["en"], forKey: Self.nativeMenuLanguagesKey)
        case .simplifiedChinese:
            defaults.set(["zh-Hans"], forKey: Self.nativeMenuLanguagesKey)
        case .system:
            defaults.removeObject(forKey: Self.nativeMenuLanguagesKey)
        }
    }

    var locale: Locale {
        switch selection {
        case .english:
            return Locale(identifier: "en")
        case .simplifiedChinese:
            return Locale(identifier: "zh_Hans")
        case .system:
            return systemLocale.languageCode?.lowercased() == "zh"
                ? Locale(identifier: "zh_Hans")
                : Locale(identifier: "en")
        }
    }
}
