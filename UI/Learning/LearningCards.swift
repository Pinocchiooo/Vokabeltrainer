//
//  LearningCard.swift
//  Abschlussprojekt_Adriano
//
//  Created by Adriano Brunster on 22.02.22.
//

import SwiftUI

struct LearningCards: View {
    
    var native: String
    var foreign: String
    @Binding var aufgedeckt: Bool
    var learningDirectionChanged: Bool
    
    var body: some View {
        VStack {
            Text(!learningDirectionChanged ? native: foreign)
                .padding()
                .frame(width: Guidelines.cardWidth, height: Guidelines.cardHeight )
                .background(CardView())
                .padding()
            Text(aufgedeckt ? !learningDirectionChanged ? foreign: native : "?")
                .padding()
                .frame(width: Guidelines.cardWidth, height: Guidelines.cardHeight )
                .background(CardView())
                .padding()
        }
    }
}
