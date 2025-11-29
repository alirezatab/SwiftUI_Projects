//
//  Step.swift
//  MinimalAnimation_FitnessApp_SwiftUI
//
//  Created by ALIREZA TABRIZI on 11/29/25.
//

import SwiftUI

//MARK: Steps Bar Graph Mpdel and Sample Data
struct Step: Identifiable {
  var id = UUID().uuidString
  var value: CFloat
  var key: String
  var color: Color = Color("Purple")
}

var steps: [Step] = [
  Step(value: 500, key: "1-4 AM"),
  Step(value: 240, key: "5-8 AM", color: Color("Green")),
  Step(value: 350, key: "9-11 AM"),
  Step(value: 430, key: "12-4 PM", color: Color("Green")),
  Step(value: 690, key: "5-8 PM"),
  Step(value: 540, key: "9-12 PM", color: Color("Green"))
]
