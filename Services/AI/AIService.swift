import Foundation

struct AIService {
    func summarize(_ input: String) -> String {
        guard !input.isEmpty else { return "" }
        return "Summary placeholder: \(input.prefix(60))"
    }
}
