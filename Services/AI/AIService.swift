import Foundation

enum MoodOption: String, CaseIterable, Identifiable, Codable {
    case calmCentered = "calm_centered"
    case anxiousOverwhelmed = "anxious_overwhelmed"
    case lowEnergy = "low_energy"
    case hopefulCurious = "hopeful_curious"
    case grievingProcessing = "grieving_processing"
    case excitedExpansive = "excited_expansive"
    case goingThroughMotions = "going_through_motions"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .calmCentered:
            "Calm & Centered"
        case .anxiousOverwhelmed:
            "Anxious & Overwhelmed"
        case .lowEnergy:
            "Low Energy"
        case .hopefulCurious:
            "Hopeful & Curious"
        case .grievingProcessing:
            "Grieving & Processing"
        case .excitedExpansive:
            "Excited & Expansive"
        case .goingThroughMotions:
            "Going Through the Motions"
        }
    }
}

enum AIProviderKind: String {
    case openAI
    case claude
}

protocol AITextProvider {
    var providerKind: AIProviderKind { get }
    func generateAffirmations(for mood: MoodOption, context: String?) throws -> [String]
}

protocol AffirmationSuggestionService {
    func suggestAffirmations(for mood: MoodOption, context: String?) -> [String]
}

struct AIService: AffirmationSuggestionService {
    private let provider: (any AITextProvider)?
    private let fallbackSets: [MoodOption: [[String]]]

    init(provider: (any AITextProvider)? = nil, fallbackSets: [MoodOption: [[String]]] = AIService.defaultFallbackSets) {
        self.provider = provider
        self.fallbackSets = fallbackSets
    }

    func suggestAffirmations(for mood: MoodOption, context: String?) -> [String] {
        if let provider,
           let generated = try? provider.generateAffirmations(for: mood, context: context),
           generated.count == 3,
           generated.allSatisfy({ !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) {
            return generated
        }

        guard let cached = fallbackSets[mood], let choice = cached.randomElement() else {
            return [
                "I welcome this moment as it is.",
                "I trust myself to take the next small step.",
                "I deserve gentleness today."
            ]
        }

        return choice
    }

    func summarize(_ input: String) -> String {
        guard !input.isEmpty else { return "" }
        return "Summary placeholder: \(input.prefix(60))"
    }
}

private extension AIService {
    static let defaultFallbackSets: [MoodOption: [[String]]] = [
        .calmCentered: [[
            "I honor the peace I have created within.",
            "I move through today with grounded clarity.",
            "My calm presence is enough."
        ]],
        .anxiousOverwhelmed: [[
            "I can take this one breath at a time.",
            "I release what is not mine to carry.",
            "I am safe to slow down and reset."
        ]],
        .lowEnergy: [[
            "Rest is productive for my healing body.",
            "I allow gentle momentum to build naturally.",
            "Small steps still move me forward."
        ]],
        .hopefulCurious: [[
            "I welcome new possibilities with an open heart.",
            "Curiosity helps me grow beyond old limits.",
            "I trust the unfolding path ahead."
        ]],
        .grievingProcessing: [[
            "My feelings are valid and worthy of space.",
            "I can honor my grief and still receive support.",
            "Healing can be slow, and that is okay."
        ]],
        .excitedExpansive: [[
            "My energy is a gift I can channel with intention.",
            "I am ready for the opportunities coming to me.",
            "I celebrate how far I have already come."
        ]],
        .goingThroughMotions: [[
            "Even routine days are part of my becoming.",
            "I can choose one meaningful moment today.",
            "I give myself credit for showing up."
        ]]
    ]
}
