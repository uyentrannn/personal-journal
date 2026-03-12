import SwiftUI

struct JournalView: View {
    let aiService: AIService
    let persistenceService: PersistenceService

    @State private var entryText = ""
    @State private var selectedMood: MoodOption = .calmCentered
    @State private var suggestionDrafts: [String] = ["", "", ""]
    @State private var selectedAffirmations: [String] = ["", "", ""]
    @State private var suggestionIgnored = false

    var body: some View {
        Form {
            Section("Today's Entry") {
                TextEditor(text: $entryText)
                    .frame(minHeight: 180)

                Button("Summarize with AI") {
                    _ = aiService.summarize(entryText)
                }
                .buttonStyle(.borderedProminent)
            }

            Section {
                Text("How are you feeling today, Uyen?")
                    .font(.headline)

                Picker("Mood", selection: $selectedMood) {
                    ForEach(MoodOption.allCases) { mood in
                        Text(mood.displayName).tag(mood)
                    }
                }
                .pickerStyle(.menu)
            }

            Section("Affirmation Suggestions") {
                if !suggestionIgnored {
                    ForEach(0..<3, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("Affirmation \(index + 1)", text: bindingForSuggestion(at: index))
                                .textFieldStyle(.roundedBorder)

                            HStack {
                                Button("Accept line") {
                                    selectedAffirmations[index] = suggestionDrafts[index]
                                    persistenceService.updateDailyEntry(
                                        mood: selectedMood,
                                        affirmations: selectedAffirmations
                                    )
                                }
                                .buttonStyle(.bordered)

                                if !selectedAffirmations[index].isEmpty {
                                    Text("Selected")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding(.vertical, 2)
                    }

                    Button("Ask for different suggestions") {
                        regenerateSuggestions()
                    }

                    Button("Ignore suggestions", role: .cancel) {
                        suggestionIgnored = true
                    }
                    .foregroundStyle(.secondary)
                } else {
                    Button("Show suggestion options") {
                        suggestionIgnored = false
                        regenerateSuggestions()
                    }
                }
            }

            Section("Selected Affirmations") {
                ForEach(0..<3, id: \.self) { index in
                    TextField("Chosen affirmation \(index + 1)", text: bindingForSelectedAffirmation(at: index))
                }
            }

            Section("Storage") {
                Text(persistenceService.statusDescription)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Journal")
        .onAppear {
            entryText = persistenceService.dailyEntry.entryText
            if let mood = persistenceService.dailyEntry.mood {
                selectedMood = mood
            }
            selectedAffirmations = persistenceService.dailyEntry.affirmations
            regenerateSuggestions()
        }
        .onChange(of: selectedMood) { _, _ in
            regenerateSuggestions()
            persistenceService.updateDailyEntry(mood: selectedMood)
        }
        .onChange(of: entryText) { _, newValue in
            persistenceService.updateDailyEntry(text: newValue)
        }
        .onChange(of: selectedAffirmations) { _, newValue in
            persistenceService.updateDailyEntry(
                mood: selectedMood,
                affirmations: newValue
            )
        }
    }

    private func regenerateSuggestions() {
        suggestionDrafts = aiService.suggestAffirmations(for: selectedMood, context: entryText)
    }

    private func bindingForSuggestion(at index: Int) -> Binding<String> {
        Binding(
            get: { suggestionDrafts[index] },
            set: { suggestionDrafts[index] = $0 }
        )
    }

    private func bindingForSelectedAffirmation(at index: Int) -> Binding<String> {
        Binding(
            get: { selectedAffirmations[index] },
            set: { selectedAffirmations[index] = $0 }
        )
    }
}
