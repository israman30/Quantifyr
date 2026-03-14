//
//  Formula.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import Foundation

struct Formula {
    let name: String
    let description: String
    let inputs: [String]
    let compute: ([Double]) -> Double
}
