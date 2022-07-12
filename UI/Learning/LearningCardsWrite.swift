//
//  LearningCardWrite.swift
//  Abschlussprojekt_Adriano
//
//  Created by Adriano Brunster on 29.03.22.
//

import SwiftUI

enum FocusField: Hashable {
    case field
}

struct LearningCardsWrite: View {
    @Binding var aufgedeckt: Bool
    var native: String
    var foreign: String
    @FocusState private var focusField: FocusField?
    @Binding var textField: String
    @Binding var submit: Bool
    @Binding var presentAlert: Bool
    var learningDirectionChanged: Bool
    
    var body: some View {
        VStack {
            Text(!learningDirectionChanged ? native: foreign)
                .padding()
                .frame(width: Guidelines.cardWidth, height: Guidelines.cardHeight )
                .background(CardView())
                .padding()
            if aufgedeckt {
                Text(textField)
                    .padding()
                    .frame(width: Guidelines.cardWidth, height: Guidelines.cardHeight )
                    .background(CardView())
                    .padding()
            } else {
                TextField("...", text: $textField)
                    .padding()
                    .frame(width: Guidelines.cardWidth, height: Guidelines.cardHeight )
                    .background(CardView())
                    .padding()
                    .multilineTextAlignment(.center)
                    .focused($focusField, equals: .field)
                    .textFieldFocusableArea()
                    .onAppear {
                        self.focusField = .field
                        textField = ""
                    }
                    .onSubmit {
                        aufgedeckt = true
                        presentAlert = true
                    }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onEnded({ value in
            if value.translation.height > 0 {
                hideKeyboard()
            }
        }))
    }
}
