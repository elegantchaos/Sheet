// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI


struct SheetView: View {
    @ObservedObject var sheet: CharacterSheet
    

    
    var body: some View {
        Text(sheet.name!)
            .font(.largeTitle)
        
        HStack {
            StatsView(sheet: sheet)
            
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
