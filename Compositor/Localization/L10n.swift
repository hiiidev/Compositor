import Foundation
import SwiftUI

nonisolated enum L10n {
    static var currentLocale: Locale {
        switch UserDefaults.standard.string(forKey: AppLanguageStore.storageKey) {
        case AppLanguage.english.rawValue:
            return Locale(identifier: "en")
        case AppLanguage.simplifiedChinese.rawValue:
            return Locale(identifier: "zh_Hans")
        default:
            return Locale.current.languageCode?.lowercased() == "zh"
                ? Locale(identifier: "zh_Hans")
                : Locale(identifier: "en")
        }
    }

    static func key(_ value: String) -> LocalizedStringKey {
        LocalizedStringKey(value)
    }

    static func text(_ key: String, locale: Locale = L10n.currentLocale) -> String {
        let bundle = localizedBundle(for: locale)
        return bundle.localizedString(forKey: key, value: key, table: "Localizable")
    }

    static func numbered(_ key: String, number: Int, locale: Locale = L10n.currentLocale) -> String {
        String(format: text("layer.numbered", locale: locale), text(key, locale: locale), number)
    }

    private static func localizedBundle(for locale: Locale) -> Bundle {
        let resource = locale.languageCode?.lowercased() == "zh" ? "zh-Hans" : "en"
        guard let path = Bundle.main.path(forResource: resource, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return Bundle.main
        }
        return bundle
    }
}

extension FilterKind {
    var localizedName: String { localizedName(locale: L10n.currentLocale) }

    func localizedName(locale: Locale) -> String {
        let key: String
        switch self {
        case .gaussianBlur: key = "gaussianBlur"
        case .motionBlur: key = "motionBlur"
        case .addNoise: key = "addNoise"
        case .vignette: key = "vignette"
        case .bloomGlow: key = "bloomGlow"
        case .dither: key = "dither"
        case .tonalContrast: key = "tonalContrast"
        case .lensCorrection: key = "lensCorrection"
        case .cameraRaw: key = "cameraRaw"
        case .removeBackground: key = "removeBackground"
        case .contentAwareFill: key = "contentAwareFill"
        case .curves: key = "curves"
        case .exposure: key = "exposure"
        case .gradientMap: key = "gradientMap"
        case .grain: key = "grain"
        case .blackWhite: key = "blackWhite"
        case .colorBalance: key = "colorBalance"
        }
        return textOrEnglish("filter.\(key)", fallback: rawValue, locale: locale)
    }

    private func textOrEnglish(_ key: String, fallback: String, locale: Locale) -> String {
        let value = L10n.text(key, locale: locale)
        return value == key ? fallback : value
    }
}

extension AdjustmentKind {
    var localizedName: String { localizedName(locale: L10n.currentLocale) }

    func localizedName(locale: Locale) -> String {
        let key: String
        switch self {
        case .hsv: key = "hueSaturation"
        case .levels: key = "levels"
        case .curves: key = "curves"
        case .exposure: key = "exposure"
        case .gradientMap: key = "gradientMap"
        case .grain: key = "grain"
        case .addNoise: key = "addNoise"
        case .gaussianBlur: key = "gaussianBlur"
        case .motionBlur: key = "motionBlur"
        case .invert: key = "invert"
        case .blackWhite: key = "blackWhite"
        case .colorBalance: key = "colorBalance"
        }
        let catalogKey = "adjustment.\(key)"
        let value = L10n.text(catalogKey, locale: locale)
        return value == catalogKey ? rawValue : value
    }
}

extension LayerBlendMode {
    var localizedName: String { localizedName(locale: L10n.currentLocale) }

    func localizedName(locale: Locale) -> String {
        let key: String
        switch self {
        case .normal: key = "normal"
        case .multiply: key = "multiply"
        case .screen: key = "screen"
        case .overlay: key = "overlay"
        case .softLight: key = "softLight"
        case .darken: key = "darkening"
        case .lighten: key = "lightening"
        case .difference: key = "difference"
        case .colorDodge: key = "colorDodge"
        case .colorBurn: key = "colorBurn"
        case .linearBurn: key = "linearBurn"
        case .linearDodge: key = "linearDodge"
        case .hardLight: key = "hardLight"
        case .vividLight: key = "vividLight"
        case .linearLight: key = "linearLight"
        case .pinLight: key = "pinLight"
        case .hardMix: key = "hardMix"
        case .hue: key = "hue"
        case .saturation: key = "saturation"
        case .color: key = "color"
        case .luminosity: key = "luminosity"
        case .exclusion: key = "exclusion"
        case .subtract: key = "subtract"
        case .divide: key = "divide"
        }
        let catalogKey = "blend.\(key)"
        let value = L10n.text(catalogKey, locale: locale)
        return value == catalogKey ? rawValue : value
    }
}

extension LayerEffectKind {
    var localizedName: String {
        L10n.text(rawValue)
    }
}

extension NavigationTool {
    func localizedLabel(locale: Locale = L10n.currentLocale) -> String {
        let key: String
        switch self {
        case .type: key = "toolLabel.type"
        case .eyedropper: key = "toolLabel.eyedropper"
        case .marquee: key = "toolLabel.marquee"
        case .lasso: key = "toolLabel.lasso"
        case .wand: key = "toolLabel.wand"
        case .brush: key = "toolLabel.brush"
        case .spotHealing: key = "toolLabel.spotHealing"
        case .cloneStamp: key = "toolLabel.cloneStamp"
        case .blur: key = "toolLabel.blur"
        case .gradient: key = "toolLabel.gradient"
        case .shape: key = "toolLabel.shape"
        case .crop: key = "toolLabel.crop"
        case .move: key = "toolLabel.move"
        case .hand: key = "toolLabel.hand"
        case .zoom: key = "toolLabel.zoom"
        case .idle: key = "toolLabel.idle"
        }
        let value = L10n.text(key, locale: locale)
        return value == key ? label : value
    }
}
