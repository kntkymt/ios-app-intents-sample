import SwiftUI

/// Displays the list of to-dos and supports inline editing and adding entries.
struct TodoScreen: View {
    private let repository = ToDoRepository()

    @State private var todos: [ToDo] = []

    var body: some View {
        NavigationStack {
            List {
                ForEach($todos) { $todo in
                    ToDoRow(todo: $todo)
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("ToDo")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: add) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .task { await load() }
    }

    private func load() async {
        todos = await repository.getTodos()
        // Index the current to-dos when the screen first appears.
        await TodoIndexer.reindex(todos)
    }

    private func add() {
        // Appending mutates `todos`, which triggers `onChange` to persist.
        todos.append(ToDo(title: "", description: ""))
    }

    private func delete(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
    }
}

/// An inline-editable row for a single to-do.
private struct ToDoRow: View {
    @Binding var todo: ToDo

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField("Title", text: $todo.title)
                .font(.headline)
            TextField("Description", text: $todo.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(todo.createdDate, format: .dateTime.year().month().day().hour().minute())
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TodoScreen()
}
