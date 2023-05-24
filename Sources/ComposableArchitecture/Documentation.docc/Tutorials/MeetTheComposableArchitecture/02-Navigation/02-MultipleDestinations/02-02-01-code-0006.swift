struct ContentView: View {
  let store: StoreOf<ContactsFeature>

  var body: some View {
    WithViewStore(self.store, observe: \.contacts) { viewStore in
      NavigationStack {
        List {
          ForEach(viewStore.state) { contact in
            Text(contact.name)
          }
        }
        .navigationTitle("Contacts")
        .toolbar {
          ToolbarItem {
            Button {
              viewStore.send(.addButtonTapped)
            } label: {
              Image(systemName: "plus")
            }
          }
        }
        .sheet(
          store: self.store.scope(
            state: \.$addContact,
            action: { .addContact($0) }
          )
        ) { addContactStore in
          NavigationStack {
            AddContactView(store: addContactStore)
          }
        }
        .alert(
          store: self.store.scope(
            state: \.$alert,
            action: { .alert($0) }
          )
        )
      }
    }
  }
}
