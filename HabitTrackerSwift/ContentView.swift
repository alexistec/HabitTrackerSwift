import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Habit.createdAt, ascending: true)],
        animation: .default)
    private var habits: FetchedResults<Habit>
    
    @State private var showingAddHabit = false
    @StateObject private var habitStore = HabitStore()
    
    var body: some View {
        NavigationView {
            VStack {
                DashboardView(habits: Array(habits))
                    .environmentObject(habitStore)
                
                List {
                    ForEach(habits) { habit in
                        NavigationLink(destination: HabitDetailView(habit: habit).environmentObject(habitStore)) {
                            HabitRowView(habit: habit)
                                .environmentObject(habitStore)
                        }
                    }
                    .onDelete(perform: deleteHabits)
                }
            }
            .navigationTitle("Habit Tracker")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddHabit = true
                    }) {
                        Label("Add Habit", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                AddHabitView()
                    .environmentObject(habitStore)
            }
        }
    }
    
    private func deleteHabits(offsets: IndexSet) {
        withAnimation {
            offsets.map { habits[$0] }.forEach(habitStore.deleteHabit)
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
} 