import SwiftUI

struct DashboardView: View {
    let habits: [Habit]
    @EnvironmentObject var habitStore: HabitStore
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Today's Progress")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top)
            
            HStack(spacing: 20) {
                StatCard(
                    title: "Total Pomodoros",
                    value: "\(totalPomodorosToday)",
                    color: .red
                )
                
                StatCard(
                    title: "Habits Worked",
                    value: "\(habitsWorkedToday)",
                    color: .blue
                )
            }
            .padding(.horizontal)
            
            if !todaysNotes.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Today's Notes")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(todaysNotes.prefix(3), id: \.id) { note in
                                NoteCard(note: note)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .padding(.bottom)
    }
    
    private var totalPomodorosToday: Int {
        habits.reduce(0) { total, habit in
            total + habitStore.getTodaysCompletedSessions(for: habit).count
        }
    }
    
    private var habitsWorkedToday: Int {
        habits.filter { habit in
            !habitStore.getTodaysCompletedSessions(for: habit).isEmpty
        }.count
    }
    
    private var todaysNotes: [Note] {
        let calendar = Calendar.current
        let today = Date()
        
        return habits.compactMap { habit in
            habit.notes?.compactMap { note in
                guard let note = note as? Note,
                      let date = note.date,
                      calendar.isDate(date, inSameDayAs: today) else {
                    return nil
                }
                return note
            }
        }.flatMap { $0 }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct NoteCard: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(note.text ?? "")
                .font(.caption)
                .lineLimit(3)
            
            if let date = note.date {
                Text(date, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 120, alignment: .leading)
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}