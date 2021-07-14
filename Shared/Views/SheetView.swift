// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

struct SheetView: View {
    @ObservedObject var sheet: CharacterSheet
    @State var editing = false
    @FocusState var nameFocussed: Bool

    var detailKeys: [BasicFantasy.Detail] {
        BasicFantasy.topDetails.filter({ sheet.has(key: $0) })
    }
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                if editing {
                    TextField("Name", text: $sheet.editableName)
                        .multilineTextAlignment(.center)
                        .focused($nameFocussed)
                } else {
                    Text(sheet.editableName)
                }
                Spacer()
            }
            .font(.largeTitle)

            let keys = detailKeys
            LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible()), count: keys.count)) {
                ForEach(keys) { key in
                    Text(LocalizedStringKey(key.rawValue))
                }

                ForEach(keys) { key in
                    if let string = sheet.string(withKey: key) {
                        Text(string)
                            .bold()
                    } else if let integer = sheet.integer(withKey: key) {
                        Text("\(integer)")
                            .bold()
                    }
                }
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
                Button(action: sheet.randomize) {
                    Text("Randomize")
                }
            }

            ToolbarItem(placement: .bottomBar) {
                Toggle("Edit", isOn: $editing)
                    .onChange(of: editing) { value in
                        nameFocussed = value
                        print(nameFocussed)
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
        sheet.randomize()
        
        return SheetView(sheet: sheet)
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .environment(\.managedObjectContext, context)
    }
}
