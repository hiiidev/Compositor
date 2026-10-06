import Foundation
import Testing
@testable import Compositor

@MainActor
struct LocalizationTests {
    @Test func englishAndChineseCatalogsHaveTheSameNonEmptyKeys() throws {
        let catalogURL = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Compositor/Resources/Localizable.xcstrings")
        let object = try JSONSerialization.jsonObject(with: Data(contentsOf: catalogURL)) as! [String: Any]
        let strings = object["strings"] as! [String: Any]
        for (key, value) in strings {
            let localizations = (value as! [String: Any])["localizations"] as! [String: Any]
            #expect(localizations["en"] != nil, "Missing English localization for \(key)")
            #expect(localizations["zh-Hans"] != nil, "Missing Simplified Chinese localization for \(key)")
        }
    }

    @Test func appLanguageUsesStableRawValues() {
        #expect(AppLanguage.system.rawValue == "system")
        #expect(AppLanguage.english.rawValue == "english")
        #expect(AppLanguage.simplifiedChinese.rawValue == "simplifiedChinese")
    }

    @Test func appLanguageStorePersistsAndRestoresSelection() {
        let suite = "LocalizationTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defaults.removePersistentDomain(forName: suite)
        let first = AppLanguageStore(defaults: defaults, systemLocale: Locale(identifier: "en_US"))
        first.selection = .simplifiedChinese
        let second = AppLanguageStore(defaults: defaults, systemLocale: Locale(identifier: "en_US"))
        #expect(second.selection == .simplifiedChinese)
        defaults.removePersistentDomain(forName: suite)
    }

    @Test func appLanguageConfiguresNativeMenuLanguage() {
        let suite = "LocalizationTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defaults.removePersistentDomain(forName: suite)
        let store = AppLanguageStore(defaults: defaults, systemLocale: Locale(identifier: "zh_CN"))

        store.selection = .english
        #expect(defaults.stringArray(forKey: "AppleLanguages") == ["en"])
        store.selection = .simplifiedChinese
        #expect(defaults.stringArray(forKey: "AppleLanguages") == ["zh-Hans"])
        store.selection = .system
        #expect(defaults.persistentDomain(forName: suite)?["AppleLanguages"] == nil)
        defaults.removePersistentDomain(forName: suite)
    }

    @Test func appLanguageResolvesChineseAndFallbackLocales() {
        #expect(AppLanguageStore(defaults: .standard, systemLocale: Locale(identifier: "zh_CN"), initial: .system, simplifiedChineseAvailable: true).locale.identifier.lowercased().contains("zh"))
        #expect(AppLanguageStore(defaults: .standard, systemLocale: Locale(identifier: "de_DE"), initial: .system, simplifiedChineseAvailable: true).locale.identifier.hasPrefix("en"))
        #expect(AppLanguageStore(defaults: .standard, systemLocale: Locale(identifier: "en_US"), initial: .simplifiedChinese, simplifiedChineseAvailable: true).locale.identifier.lowercased().contains("zh"))
    }

    @Test func englishOnlyPackageHidesChineseAndFallsBackSafely() {
        let suite = "LocalizationTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defaults.removePersistentDomain(forName: suite)
        defaults.set(AppLanguage.simplifiedChinese.rawValue, forKey: AppLanguageStore.storageKey)

        let store = AppLanguageStore(
            defaults: defaults,
            systemLocale: Locale(identifier: "zh_CN"),
            simplifiedChineseAvailable: false
        )
        #expect(store.supportsSimplifiedChinese == false)
        #expect(store.selection == .english)
        #expect(store.locale.identifier.hasPrefix("en"))
        #expect(defaults.stringArray(forKey: AppLanguageStore.nativeMenuLanguagesKey) == ["en"])
        defaults.removePersistentDomain(forName: suite)
    }

    @Test func representativeChineseStringsRender() {
        let zh = Locale(identifier: "zh_Hans")
        #expect(L10n.text("settings.language", locale: zh) == "语言")
        #expect(L10n.text("menu.edit.undo", locale: zh) == "撤销")
        #expect(L10n.text("toolLabel.type", locale: zh) == "文字工具 (T)")
        #expect(L10n.text("Font", locale: zh) == "字体")
        #expect(L10n.text("Type", locale: zh) == "文字")
        #expect(L10n.text("Content-Aware Fill", locale: zh) == "内容识别填充")
        #expect(L10n.text("unknown.localization.key", locale: zh) == "unknown.localization.key")
    }

    @Test func enumDisplayNamesDoNotChangeSerializedValues() {
        #expect(LayerBlendMode.normal.rawValue == "Normal")
        #expect(LayerBlendMode.colorDodge.rawValue == "Color Dodge")
        #expect(FilterKind.contentAwareFill.rawValue == "Content-Aware Fill")
        #expect(AdjustmentKind.hsv.rawValue == "Hue/Saturation")
    }

    @Test func chineseEnumDisplayNamesUseImageEditingTerminology() {
        let zh = Locale(identifier: "zh_Hans")
        #expect(LayerBlendMode.multiply.localizedName(locale: zh) == "正片叠底")
        #expect(FilterKind.contentAwareFill.localizedName(locale: zh) == "内容识别填充")
        #expect(AdjustmentKind.hsv.localizedName(locale: zh) == "色相/饱和度")
        #expect(FilterKind.cameraRaw.localizedName(locale: zh) == "Camera Raw 滤镜")
    }
}
