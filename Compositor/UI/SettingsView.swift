import SwiftUI

struct SettingsView: View {
    @ObservedObject var languageStore: AppLanguageStore

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L10n.key("settings.language")).font(.headline)
            Picker(L10n.key("settings.language"), selection: $languageStore.selection) {
                Text(L10n.key("settings.language.system")).tag(AppLanguage.system)
                Text(L10n.key("settings.language.english")).tag(AppLanguage.english)
                Text(L10n.key("settings.language.chinese")).tag(AppLanguage.simplifiedChinese)
            }
            .pickerStyle(.menu)

            Text(L10n.key("dialog.languageRestart"))
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .frame(width: 380)
        .padding(24)
    }
}

struct SettingsWindowRoot: View {
    @ObservedObject var languageStore: AppLanguageStore

    var body: some View {
        SettingsView(languageStore: languageStore)
            .environment(\.locale, languageStore.locale)
    }
}
