// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

struct SheetView: View {
    @ObservedObject var sheet: CharacterSheet
    
    let labels = ["race", "gender"]
    
    var detailKeys: [BasicFantasy.Detail] {
        BasicFantasy.Detail.allCases.filter({ sheet.has(key: $0.rawValue) })
    }
    
    var body: some View {
        
        
        Text(sheet.name!)
            .font(.largeTitle)

        let keys = detailKeys
        LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible()), count: keys.count)) {
            ForEach(keys) { key in
                Text(key.rawValue)
            }

            ForEach(keys) { key in
                if let string = sheet.string(withKey: key.rawValue) {
                    Text(string)
                } else if let integer = sheet.integer(withKey: key.rawValue) {
                    Text("\(integer)")
                }
            }
        }
        
        HStack {
            AbilitiesView(sheet: sheet)
            
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
