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

extension ColorPickerTarget {
    var localizedTitle: String {
        let picker = L10n.text("Color Picker")
        let detail: String
        switch self {
        case .text:
            detail = L10n.text("Text color")
        case .effect(let kind):
            detail = kind.localizedName + " " + L10n.text("Color").lowercased()
        case .palette(let background):
            detail = L10n.text(background ? "Background color" : "Foreground color")
        case .gradientMap(let highlights):
            detail = L10n.text(highlights ? "Gradient Map highlights" : "Gradient Map shadows")
        case .vignette:
            detail = L10n.text("Vignette") + " " + L10n.text("Color").lowercased()
        case .dither(let light):
            detail = L10n.text(light ? "Dither Light Color" : "Dither Dark Color")
        case .dialog(let title):
            detail = L10n.text(title)
        }
        return picker + " (" + detail + ")"
    }
}

extension L10n {
    @MainActor
    static func statusHint(for session: EditorSession, locale: Locale = L10n.currentLocale) -> String {
        let key: String
        switch session.tool {
        case .marquee:
            key = session.marqueeKind == .ellipse ? "status.marquee.ellipse" : "status.marquee.rectangle"
        case .wand:
            key = session.wandMode == .object ? "status.wand.object" : "status.wand.wand"
        case .lasso:
            key = session.lassoKind == .freehand ? "status.lasso.freehand" : "status.lasso.polygonal"
        case .brush:
            key = session.brushMode == .erase ? "status.brush.erase" : "status.brush.paint"
        case .blur:
            key = session.blurMode == .blur ? "status.blur.blur" : session.blurMode == .smudge ? "status.blur.smudge" : "status.blur.liquify"
        case .cloneStamp: key = "status.cloneStamp"
        case .spotHealing: key = "status.spotHealing"
        case .type: key = "status.type"
        case .shape:
            key = session.shapeKind == .line ? "status.shape.line" : session.shapeKind == .rectangle ? "status.shape.rectangle" : "status.shape.ellipse"
        case .gradient: key = "status.gradient"
        case .crop: key = "status.crop"
        case .move: key = "status.move"
        case .hand: key = "status.hand"
        case .idle: key = "status.idle"
        case .zoom: key = "status.zoom"
        case .eyedropper: return text("Eyedropper", locale: locale)
        }
        return text(key, locale: locale)
    }
}

extension ShortcutDefinition {
    var localizedTitle: String { localizedTitle(locale: L10n.currentLocale) }

    func localizedTitle(locale: Locale) -> String {
        if title.hasSuffix(" by 10") {
            let base = String(title.dropLast(" by 10".count))
            return String(format: L10n.text("shortcuts.byTen", locale: locale), L10n.text(base, locale: locale))
        }
        if title.hasPrefix("Opacity digit "), let digit = title.dropFirst("Opacity digit ".count).first {
            return String(format: L10n.text("shortcuts.opacityDigit", locale: locale), String(digit))
        }
        for prefix in ["Nudge ", "Move selected pixels "] where title.hasPrefix(prefix) {
            let rest = String(title.dropFirst(prefix.count))
            let pieces = rest.split(separator: " ", maxSplits: 2).map(String.init)
            if pieces.count == 3, let distance = Int(pieces[1]) {
                let directionKey = ["Left": "shortcuts.direction.left", "Right": "shortcuts.direction.right",
                                    "Up": "shortcuts.direction.up", "Down": "shortcuts.direction.down"][pieces[0]] ?? pieces[0]
                let direction = L10n.text(directionKey, locale: locale)
                let key = prefix.hasPrefix("Nudge") ? "shortcuts.nudge" : "shortcuts.movePixels"
                return String(format: L10n.text(key, locale: locale), direction, distance)
            }
        }
        return L10n.text(title, locale: locale)
    }
}
