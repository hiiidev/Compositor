import AppKit
import SwiftUI

/// Small availability shims for keeping the upstream UI behavior while supporting macOS 14 and 15.
enum CompatFrameResizePosition {
    case topLeft, top, topRight, right, bottomRight, bottom, bottomLeft, left
}

extension NSCursor {
    static func frameResizeCompat(_ position: CompatFrameResizePosition) -> NSCursor {
        if #available(macOS 15.0, *) {
            let native: NSCursor.FrameResizePosition
            switch position {
            case .topLeft: native = .topLeft
            case .top: native = .top
            case .topRight: native = .topRight
            case .right: native = .right
            case .bottomRight: native = .bottomRight
            case .bottom: native = .bottom
            case .bottomLeft: native = .bottomLeft
            case .left: native = .left
            }
            return .frameResize(position: native, directions: [.inward, .outward])
        }

        switch position {
        case .top, .bottom: return .resizeUpDown
        case .left, .right: return .resizeLeftRight
        case .topLeft, .topRight, .bottomLeft, .bottomRight: return .crosshair
        }
    }
}

extension View {
    @ViewBuilder
    func macOS14ColumnResizePointer() -> some View {
        if #available(macOS 15.0, *) { pointerStyle(.columnResize) }
        else { self }
    }
}
