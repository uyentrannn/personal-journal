import SwiftUI

struct RootTabView: View {
    let container: AppContainer

    var body: some View {
        TabView {
            NavigationStack {
                JournalView(
                    aiService: container.aiService,
                    persistenceService: container.persistenceService
                )
            }
            .tabItem {
                Label("Journal", systemImage: "book.closed")
            }

            NavigationStack {
                ArchiveView(persistenceService: container.persistenceService)
            }
            .tabItem {
                Label("Archive", systemImage: "archivebox")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape")
            }
        }
    }
}
