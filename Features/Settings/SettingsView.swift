import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Section("General") {
                Toggle("Use Face ID", isOn: .constant(true))
                Toggle("Daily Reminder", isOn: .constant(false))
            }

            Section("About") {
                Text("Personal Journal")
                Text("Version 0.1.0")
            }
        }
        .navigationTitle("Settings")
    }
}
