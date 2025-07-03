import SwiftUI

struct HabitRowView: View {
    let habit: Habit
    @EnvironmentObject var habitStore: HabitStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(habit.title ?? "Untitled Habit")
                        .font(.headline)
                    
                    if let description = habit.habitDescription, !description.isEmpty {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(todaysCompletedSessions) 🍅")
                        .font(.headline)
                        .foregroundColor(.red)
                    
                    Text("today")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Progress bar
            ProgressView(value: progressValue, total: 1.0)
                .progressViewStyle(LinearProgressViewStyle(tint: .red))
                .scaleEffect(x: 1, y: 0.8)
        }
        .padding(.vertical, 4)
    }
    
    private var todaysCompletedSessions: Int {
        habitStore.getTodaysCompletedSessions(for: habit).count
    }
    
    private var progressValue: Double {
        let completed = Double(todaysCompletedSessions)
        let target = 4.0 // Target of 4 pomodoros per day
        return min(completed / target, 1.0)
    }
}