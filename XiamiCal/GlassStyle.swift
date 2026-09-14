import SwiftUI

enum CalendarStyle {
  static let accent = Color.accentColor
  static let rest = Color("HolidayColor")
}

/// Native Liquid Glass on macOS 26, with a material fallback for older systems.
struct CalendarGlass: ViewModifier {
  @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
  @Environment(\.colorSchemeContrast) private var contrast
  var radius: CGFloat = 16
  var interactive = false

  @ViewBuilder
  func body(content: Content) -> some View {
    let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)
    if reduceTransparency {
      content.background(Color(nsColor: .controlBackgroundColor), in: shape)
        .overlay(shape.strokeBorder(.primary.opacity(contrast == .increased ? 0.45 : 0.12)))
    } else if #available(macOS 26.0, *) {
      content.glassEffect(.regular.interactive(interactive), in: shape)
    } else {
      content.background(.regularMaterial, in: shape)
        .overlay(shape.strokeBorder(.primary.opacity(contrast == .increased ? 0.45 : 0.1)))
    }
  }
}

extension View {
  func calendarGlass(radius: CGFloat = 16, interactive: Bool = false) -> some View {
    modifier(CalendarGlass(radius: radius, interactive: interactive))
  }

  @ViewBuilder
  func calendarFocusAppearance() -> some View {
    if #available(macOS 14.0, *) {
      // The selected day supplies the focus indicator instead of outlining the grid.
      self.focusEffectDisabled()
    } else {
      self
    }
  }
}

struct CalendarSurface: View {
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

  var body: some View {
    ZStack {
      if reduceTransparency {
        Color(nsColor: .windowBackgroundColor)
      } else {
        Rectangle().fill(.ultraThinMaterial)
        LinearGradient(
          colors: [CalendarStyle.accent.opacity(colorScheme == .dark ? 0.12 : 0.08), .clear, Color.white.opacity(0.025)],
          startPoint: .topLeading, endPoint: .bottomTrailing
        )
      }
    }
    .allowsHitTesting(false)
    .accessibilityHidden(true)
  }
}

struct CalendarControlStyle: ButtonStyle {
  @Environment(\.accessibilityReduceMotion) private var reduceMotion
  @Environment(\.isEnabled) private var isEnabled

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .foregroundStyle(.primary)
      .opacity(isEnabled ? (configuration.isPressed ? 0.6 : 1) : 0.35)
      .scaleEffect(configuration.isPressed && !reduceMotion ? 0.94 : 1)
      .animation(reduceMotion ? nil : .easeOut(duration: 0.12), value: configuration.isPressed)
  }
}
