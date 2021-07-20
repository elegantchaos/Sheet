// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

struct SheetView: View {
    @EnvironmentObject var context: Context
    @EnvironmentObject var system: GameSystem

    @ObservedObject var sheet: Record
    @FocusState var nameFocussed: Bool

    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                EditableStatView(sheet: sheet, key: .name)
                    .focused($nameFocussed)
                Spacer()
            }
            .font(.largeTitle)

            SheetHeaderView(sheet: sheet)
                .padding()
            
            HStack(alignment: .top) {
                AbilitiesView(sheet: sheet)
                SavingThrowsView(sheet: sheet)
                Spacer()
                    .frame(maxWidth: .infinity)
            }
            .padding()

            InventoryView(sheet: sheet)
            
            Spacer()
        }
        .toolbar {
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

            ToolbarItem(placement: .bottomBar) {
                Button(action: { system.randomize(sheet: sheet) }) {
                    Text("Randomize")
                }
            }
        }
    }

}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let sheet = Record(context: context)
        let system = BasicFantasy(savingThrows: try! SavingThrowTable(), itemIndex: try! ItemIndex())
        system.randomize(sheet: sheet)
        
        return SheetView(sheet: sheet)
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .environment(\.managedObjectContext, context)
            .environmentObject(system)
    }
}
