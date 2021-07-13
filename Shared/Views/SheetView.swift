// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

struct SheetView: View {
    @ObservedObject var sheet: CharacterSheet
    @EnvironmentObject var savingThrows: SavingThrowTable
    
    var detailKeys: [BasicFantasy.Detail] {
        BasicFantasy.topDetails.filter({ sheet.has(key: $0) })
    }
    
    var body: some View {
        
        
        Text(sheet.name!)
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
        
        HStack {
            AbilitiesView(sheet: sheet)
            
            if let cclass = sheet.characterClass, let level = sheet.integer(withKey: .level) {
                VStack {
                    ForEach(BasicFantasy.SavingThrow.allCases) { savingThrow in
                        if let value = savingThrows.value(for: savingThrow, class: cclass, level: level) {
                            Text(savingThrow.label)
                            Text(value, format: .number)
                        }
                    }
                }
            }

            Spacer()
                .frame(maxWidth: .infinity)
        }
        
        Spacer()
        
        Button(action: sheet.randomize) {
            Text("Randomize")
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
