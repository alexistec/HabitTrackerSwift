import Foundation
import CoreData
import SwiftUI

class HabitStore: ObservableObject {
    private let persistenceController = PersistenceController.shared
    
    func addHabit(title: String, description: String?) {
        let context = persistenceController.container.viewContext
        let habit = Habit(context: context)
        habit.id = UUID()
        habit.title = title
        habit.habitDescription = description
        habit.createdAt = Date()
        
        persistenceController.save()
    }
    
    func updateHabit(_ habit: Habit, title: String, description: String?) {
        habit.title = title
        habit.habitDescription = description
        
        persistenceController.save()
    }
    
    func deleteHabit(_ habit: Habit) {
        let context = persistenceController.container.viewContext
        context.delete(habit)
        
        persistenceController.save()
    }
    
    func addPomodoroSession(to habit: Habit, isBreak: Bool = false) {
        let context = persistenceController.container.viewContext
        let session = PomodoroSession(context: context)
        session.id = UUID()
        session.startTime = Date()
        session.isBreak = isBreak
        session.habit = habit
        
        persistenceController.save()
    }
    
    func completePomodoroSession(_ session: PomodoroSession) {
        session.endTime = Date()
        persistenceController.save()
    }
    
    func addNote(to habit: Habit, text: String) {
        let context = persistenceController.container.viewContext
        let note = Note(context: context)
        note.id = UUID()
        note.text = text
        note.date = Date()
        note.habit = habit
        
        persistenceController.save()
    }
    
    func getTodaysSessions(for habit: Habit) -> [PomodoroSession] {
        let calendar = Calendar.current
        let today = Date()
        
        return habit.sessions?.compactMap { session in
            guard let pomodoroSession = session as? PomodoroSession,
                  let startTime = pomodoroSession.startTime,
                  calendar.isDate(startTime, inSameDayAs: today) else {
                return nil
            }
            return pomodoroSession
        } ?? []
    }
    
    func getTodaysCompletedSessions(for habit: Habit) -> [PomodoroSession] {
        return getTodaysSessions(for: habit).filter { $0.endTime != nil && !$0.isBreak }
    }
}