//
//  Card.swift
//  Abschlussprojekt_Adriano
//
//  Created by Adriano Brunster on 19.02.22.
//

import SwiftUI

/// a custom card view
struct CardView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: Guidelines.cornerRadius, style: .continuous)
            .fill(.quaternary)
                  .shadow(radius: Guidelines.cornerRadius)
      }
}

