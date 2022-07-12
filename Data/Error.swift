//
//  Error.swift
//  Abschlussprojekt_Adriano
//
//  Created by Adriano Brunster on 09.04.22.
//

import Foundation

//all errortypes can be defined here
enum customError: Error {
    case parsingCSV
    case loadingURL
}
