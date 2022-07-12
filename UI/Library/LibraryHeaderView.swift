//
//  LibraryHeaderView.swift
//  Abschlussprojekt_Adriano
//
//  Created by Adriano Brunster on 20.02.22.
//

import SwiftUI

struct LibraryHeaderView: View {
    
    @Binding var text: String
    @Binding var orderedBy: Vocable.filterOption
    @Binding var orderDirectionFromLow: Bool
    
    
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack {
            TextField("Suchen nach ...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray4))
                .cornerRadius(Guidelines.cornerRadius)
                .padding(.horizontal, 10)
                .onTapGesture {
                    hideKeyboard()
                }
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onEnded({ value in
                    
                    if value.translation.height > 0 {
                        hideKeyboard()
                    }
                }))
            HStack {
                Text("Sortierung:")
                Picker("ordered by:", selection: $orderedBy) {
                    ForEach(Vocable.filterOption.allCases) { option in
                        Text(option.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                Button {
                    orderDirectionFromLow.toggle()
                } label: {
                    if orderDirectionFromLow {
                        Image(systemName: "arrow.down")
                    } else {
                        Image(systemName: "arrow.up")
                    }
                }
            }
        }
    }
}
