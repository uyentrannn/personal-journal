import SwiftUI

@main
struct PersonalJournalApp: App {
    private let container = AppContainer.live

    var body: some Scene {
        WindowGroup {
            RootTabView(container: container)
        }
    }
}
