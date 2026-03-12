import SwiftUI

struct ArchiveView: View {
    let persistenceService: PersistenceService

    var body: some View {
        List {
            Text("Archived entries will appear here")
            Text(persistenceService.statusDescription)
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Archive")
    }
}
