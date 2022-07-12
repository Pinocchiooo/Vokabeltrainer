//
//  LibraryView.swift
//  Abschlussprojekt_Adriano
//
//  Created by Adriano Brunster on 19.02.22.
//

import SwiftUI

struct LibraryViewController: View {
    @State var searchText: String = ""
    @ObservedObject private var viewModel = LibraryViewModel()
    @State var orderBy: Vocable.filterOption = .native
    @State var orderDirectionFromLow = true
    
    var body: some View {
        VStack {
            LibraryHeaderView(text: $searchText, orderedBy: $orderBy, orderDirectionFromLow: $orderDirectionFromLow)
                .padding()
            LibraryContentView(levelArray: viewModel.getVocsInLevelArray(orderedBy: orderBy, orderDirectionFromLow: orderDirectionFromLow, searchText: searchText))
        }
    }
}
