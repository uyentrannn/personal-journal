import Foundation

struct AppContainer {
    let aiService: AIService
    let persistenceService: PersistenceService

    static let live = AppContainer(
        aiService: AIService(),
        persistenceService: PersistenceService()
    )
}
