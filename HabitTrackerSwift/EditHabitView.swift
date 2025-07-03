import SwiftUI

struct EditHabitView: View {
    let habit: Habit
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var habitStore: HabitStore
    
    @State private var title: String
    @State private var description: String
    
    init(habit: Habit) {
        self.habit = habit
        self._title = State(initialValue: habit.title ?? "")
        self._description = State(initialValue: habit.habitDescription ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Habit Details")) {
                    TextField("Title", text: $title)
                    TextField("Description (optional)", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Edit Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveHabit()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveHabit() {
        let habitDescription = description.isEmpty ? nil : description
        habitStore.updateHabit(habit, title: title, description: habitDescription)
        presentationMode.wrappedValue.dismiss()
    }
}