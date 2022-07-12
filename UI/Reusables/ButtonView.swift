//
//  Button.swift
//  Abschlussprojekt_Adriano
//
//  Created by Adriano Brunster on 19.02.22.
//

import SwiftUI

/// a curstom button view
struct CustomButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 25)
            .padding(.vertical, 10)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(Guidelines.cornerRadius)
    }
}
