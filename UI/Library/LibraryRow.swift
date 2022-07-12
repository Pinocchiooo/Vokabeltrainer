//
//  LibraryRow.swift
//  Abschlussprojekt_Adriano
//
//  Created by Adriano Brunster on 20.02.22.
//

import SwiftUI

struct LibraryRow: View {
    var vocable: Vocable
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(vocable.native)
                Text(vocable.foreign)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("Fehler: " + String(vocable.failure))
            }
        }
    }
}
