import Foundation
import SwiftUI

class PomodoroTimer: ObservableObject {
    @Published var timeRemaining: TimeInterval = 25 * 60 // 25 minutes in seconds
    @Published var isRunning = false
    @Published var isBreak = false
    @Published var currentSession: PomodoroSession?
    
    private var timer: Timer?
    private let workDuration: TimeInterval = 25 * 60 // 25 minutes
    private let breakDuration: TimeInterval = 5 * 60 // 5 minutes
    
    private let habitStore = HabitStore()
    
    func startTimer(for habit: Habit) {
        if !isRunning {
            isRunning = true
            timeRemaining = isBreak ? breakDuration : workDuration
            
            // Create new session
            habitStore.addPomodoroSession(to: habit, isBreak: isBreak)
            
            // Get the newly created session
            currentSession = habitStore.getTodaysSessions(for: habit).last
            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.completeSession()
                }
            }
        }
    }
    
    func pauseTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        
        if let session = currentSession {
            habitStore.completePomodoroSession(session)
        }
        
        currentSession = nil
        timeRemaining = workDuration
    }
    
    private func completeSession() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        
        if let session = currentSession {
            habitStore.completePomodoroSession(session)
        }
        
        currentSession = nil
        
        // Toggle between work and break
        if !isBreak {
            isBreak = true
            timeRemaining = breakDuration
        } else {
            isBreak = false
            timeRemaining = workDuration
        }
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}