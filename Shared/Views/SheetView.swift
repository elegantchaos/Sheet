// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

struct SheetView: View {
    @EnvironmentObject var context: Context
    @EnvironmentObject var system: GameSystem

    @ObservedObject var sheet: CharacterSheet
    @FocusState var nameFocussed: Bool

    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                EditableStringView(value: sheet.editableString(forKey: .name))
                    .focused($nameFocussed)
                Spacer()
            }
            .font(.largeTitle)

            let keys = system.topStats
            LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible()), count: keys.count)) {
                ForEach(keys) { key in
                    Text(LocalizedStringKey(key.rawValue))
                }

                ForEach(keys) { key in
                    if key.isCalculated {
                        if let string = sheet.string(forKey: key) {
                            Text(string)
                        } else if let integer = sheet.integer(forKey: key) {
                            Text("\(integer)")
                        }
                    } else {
                        if let _ = sheet.string(forKey: key) {
                            EditableStringView(value: sheet.editableString(forKey: key))
                        } else {
                            EditableIntegerView(value: sheet.editableInteger(forKey: key))
                        }
                    }
                }
                .font(.body.weight(.bold))
            }
            
            HStack(alignment: .top) {
                AbilitiesView(sheet: sheet)
                SavingThrowsView(sheet: sheet)
                Spacer()
                    .frame(maxWidth: .infinity)
            }
            
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: { system.randomize(sheet: sheet) }) {
                    Text("Randomize")
                }
            }

            ToolbarItem(placement: .bottomBar) {
                Toggle("Edit", isOn: $context.editing)
                    .onChange(of: context.editing) { value in
                        nameFocussed = value
                        if !value {
                            try? sheet.save()
                        }
                    }
                    .toggleStyle(SwitchToggleStyle())
            }

        }
    }

}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let sheet = CharacterSheet(context: context)
        let system = BasicFantasy(savingThrows: SavingThrowTable())
        system.randomize(sheet: sheet)
        
        return SheetView(sheet: sheet)
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .environment(\.managedObjectContext, context)
            .environmentObject(system)
    }
}
