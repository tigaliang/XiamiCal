import SwiftUI
import ServiceManagement

final class AppPreferences: ObservableObject {
  static let shared = AppPreferences()
  @Published var showsMenuBarDate: Bool {
    didSet { defaults.set(showsMenuBarDate, forKey: "showsMenuBarDate") }
  }
  private let defaults: UserDefaults

  init(defaults: UserDefaults = .standard) {
    self.defaults = defaults
    showsMenuBarDate = defaults.bool(forKey: "showsMenuBarDate")
  }
}

enum ProductLinks {
  static let download = URL(string: "https://apps.apple.com/app/id1633055190")!
  static let help = URL(string: "https://github.com/tigaliang/XiamiCal#readme")!
  static let feedback = URL(string: "https://github.com/tigaliang/XiamiCal/issues")!
}

struct AppPreferencesView: View {
  @ObservedObject var preferences: AppPreferences
  @State private var startsAtLogin = false
  @State private var needsApproval = false
  @State private var isUpdating = false
  @State private var loginError: String?

  var body: some View {
    VStack(alignment: .leading, spacing: 22) {
      VStack(alignment: .leading, spacing: 6) {
        Text("虾米日历设置").font(.title2.bold())
        Text("随手查农历、放假和补班").foregroundStyle(.secondary)
      }
      VStack(alignment: .leading, spacing: 8) {
        Toggle("菜单栏显示日期与星期", isOn: $preferences.showsMenuBarDate)
        Text("关闭时只显示图标，适合菜单栏空间较少的 Mac。")
          .font(.callout).foregroundStyle(.secondary)
      }
      Divider()
      if #available(macOS 13.0, *) {
        VStack(alignment: .leading, spacing: 8) {
          Toggle("登录 Mac 时启动", isOn: Binding(get: { startsAtLogin }, set: setStartsAtLogin))
            .disabled(isUpdating)
          Text("登录后静默出现在菜单栏，点一下即可查看日历。")
            .font(.callout).foregroundStyle(.secondary)
          if needsApproval {
            Text("请在系统设置中允许虾米日历登录时启动。")
              .font(.callout)
            Button("打开登录项设置") { SMAppService.openSystemSettingsLoginItems() }
          }
          if let loginError {
            Text(loginError).font(.callout).foregroundStyle(.red)
              .fixedSize(horizontal: false, vertical: true)
          }
        }
      } else {
        VStack(alignment: .leading, spacing: 8) {
          Text("登录 Mac 时启动").fontWeight(.medium)
          Text("macOS 12：打开系统偏好设置 → 用户与群组 → 登录项，点击“+”添加虾米日历。")
            .font(.callout).foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
          Button("打开系统偏好设置") {
            NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preferences.users")!)
          }
        }
      }
      Divider()
      Text("应用不收集使用数据。公历与农历离线可查；中国大陆放假调休安排已收录 2022–2026 年，其他年份会明确提示。")
        .font(.callout).foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
      HStack(spacing: 16) {
        Link("使用帮助", destination: ProductLinks.help)
        Link("反馈问题", destination: ProductLinks.feedback)
      }
    }
    .padding(28)
    .frame(width: 420)
    .onAppear(perform: refreshLoginStatus)
    .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
      refreshLoginStatus()
    }
  }

  private func refreshLoginStatus() {
    if #available(macOS 13.0, *) {
      let status = SMAppService.mainApp.status
      startsAtLogin = status == .enabled || status == .requiresApproval
      needsApproval = status == .requiresApproval
    }
  }

  private func setStartsAtLogin(_ enabled: Bool) {
    guard !isUpdating else { return }
    if #available(macOS 13.0, *) {
      isUpdating = true
      loginError = nil
      Task { @MainActor in
        do {
          if enabled { try SMAppService.mainApp.register() }
          else { try await SMAppService.mainApp.unregister() }
        } catch {
          loginError = "未能更新登录启动设置。请确认应用已放入“应用程序”文件夹，再重试。"
        }
        refreshLoginStatus()
        isUpdating = false
      }
    }
  }
}

struct HolidayDataView: View {
  let year: Int

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("假期数据说明").font(.title2.bold())
      if let source = HolidayScheduleSource.forYear(year) {
        Text("\(String(year)) 年中国大陆放假调休安排已收录。")
        Link(source.title, destination: source.url)
      } else {
        Text("\(String(year)) 年调休安排暂未收录。")
        Text("未收录不代表官方尚未公布，也不能据此判断某天上班或放假。")
      }
      Text("“休”“班”来自国务院办公厅年度安排；周末颜色仅用于区分星期。实际工作安排请以所在单位通知为准。")
      Text("公历固定节日和农历传统节日独立计算，闰月不重复标记传统节日。清明日期已收录 2022–2026 年。")
      Text("放假调休数据通过应用更新补充，当前覆盖 2022–2026 年。")
      Link("反馈日期问题", destination: ProductLinks.feedback)
    }
    .font(.callout)
    .fixedSize(horizontal: false, vertical: true)
    .padding(28)
    .frame(width: 420)
  }
}
