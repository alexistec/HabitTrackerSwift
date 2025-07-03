import SwiftUI

struct HabitDetailView: View {
    let habit: Habit
    @EnvironmentObject var habitStore: HabitStore
    @StateObject private var pomodoroTimer = PomodoroTimer()
    @State private var showingAddNote = false
    @State private var showingEditHabit = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(habit.title ?? "Untitled Habit")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    if let description = habit.habitDescription, !description.isEmpty {
                        Text(description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Pomodoro Timer
                PomodoroTimerView(timer: pomodoroTimer, habit: habit)
                    .padding(.horizontal)
                
                // Today's Progress
                TodaysProgressView(habit: habit)
                    .environmentObject(habitStore)
                    .padding(.horizontal)
                
                // Notes Section
                NotesSection(habit: habit, showingAddNote: $showingAddNote)
                    .environmentObject(habitStore)
                    .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showingEditHabit = true
                }
            }
        }
        .sheet(isPresented: $showingAddNote) {
            AddNoteView(habit: habit)
                .environmentObject(habitStore)
        }
        .sheet(isPresented: $showingEditHabit) {
            EditHabitView(habit: habit)
                .environmentObject(habitStore)
        }
    }
}

struct PomodoroTimerView: View {
    @ObservedObject var timer: PomodoroTimer
    let habit: Habit
    
    var body: some View {
        VStack(spacing: 16) {
            Text(timer.isBreak ? "Break Time" : "Work Time")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(timer.isBreak ? .green : .red)
            
            Text(timer.formatTime(timer.timeRemaining))
                .font(.system(size: 48, weight: .bold, design: .monospaced))
                .foregroundColor(timer.isBreak ? .green : .red)
            
            HStack(spacing: 20) {
                if timer.isRunning {
                    Button("Pause") {
                        timer.pauseTimer()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                    Button("Stop") {
                        timer.stopTimer()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                } else {
                    Button("Start") {
                        timer.startTimer(for: habit)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(timer.isBreak ? .green : .red)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct TodaysProgressView: View {
    let habit: Habit
    @EnvironmentObject var habitStore: HabitStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Progress")
                .font(.headline)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(completedSessions) Pomodoros")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Completed today")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .fill(index < completedSessions ? Color.red : Color.gray.opacity(0.3))
                        .frame(width: 20, height: 20)
                }
            }
            
            ProgressView(value: Double(completedSessions), total: 4.0)
                .progressViewStyle(LinearProgressViewStyle(tint: .red))
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var completedSessions: Int {
        habitStore.getTodaysCompletedSessions(for: habit).count
    }
}

struct NotesSection: View {
    let habit: Habit
    @Binding var showingAddNote: Bool
    @EnvironmentObject var habitStore: HabitStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Notes")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    showingAddNote = true
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                }
            }
            
            if todaysNotes.isEmpty {
                Text("No notes for today")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ForEach(todaysNotes, id: \.id) { note in
                    NoteRowView(note: note)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var todaysNotes: [Note] {
        let calendar = Calendar.current
        let today = Date()
        
        return habit.notes?.compactMap { note in
            guard let note = note as? Note,
                  let date = note.date,
                  calendar.isDate(date, inSameDayAs: today) else {
                return nil
            }
            return note
        } ?? []
    }
}

struct NoteRowView: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(note.text ?? "")
                .font(.body)
            
            if let date = note.date {
                Text(date, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}