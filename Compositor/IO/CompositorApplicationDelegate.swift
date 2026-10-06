import AppKit
import Sparkle

final class CompositorApplicationDelegate: NSObject, NSApplicationDelegate {
    let workspace = ProjectWorkspace()
    var session: EditorSession { workspace.current.session }
    var projects: ProjectController { workspace.current.controller }
    var showEditor: (() -> Void)?
    private var editorWindow: NSWindow? {
        NSApp.windows.first { window in
            window.level == .normal && window.styleMask.contains(.titled)
        }
    }

    func showEditorWindow() {
        if let window = editorWindow {
            window.makeKeyAndOrderFront(nil)
        }
        NSApp.activate(ignoringOtherApps: true)
    }
    /// Checks the update feed and installs new versions (Sparkle). Started only after launch: its first-run prompt,
    /// shown during launch, kept the editor window from ever opening.
    let updater = SPUStandardUpdaterController(startingUpdater: false, updaterDelegate: nil, userDriverDelegate: nil)

    // Finder Open With and Dock drops, including files delivered during launch.
    func application(_ application: NSApplication, open urls: [URL]) {
        if editorWindow?.isVisible != true { showEditor?() }
        application.activate(ignoringOtherApps: true)
        Task { await workspace.receive(urls) }
    }

    func applicationWillFinishLaunching(_ notification: Notification) {
        // Always dark, alerts and open/save panels included, whatever the Mac is set to.
        NSApp.appearance = NSAppearance(named: .darkAqua)
        // Slider knobs snap to a click on the track instead of gliding there.
        SliderSnap.install()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [updater] in updater.startUpdater() }
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag { showEditor?() }
        return true
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        // What's still open (a dialog, a gradient waiting for Apply) is settled by confirmQuit, which beeps if
        // something, a save still running say, has to finish first.
        guard !workspace.isManaging else { return .terminateCancel }
        Task { sender.reply(toApplicationShouldTerminate: await workspace.confirmQuit()) }
        return .terminateLater
    }
}
