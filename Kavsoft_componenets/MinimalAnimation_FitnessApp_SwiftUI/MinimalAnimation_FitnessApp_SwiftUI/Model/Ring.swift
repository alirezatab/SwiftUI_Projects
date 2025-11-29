//
//  Ring.swift
//  MinimalAnimation_FitnessApp_SwiftUI
//
//  Created by ALIREZA TABRIZI on 11/29/25.
//

// Since this is a Tutorial only, importing SwiftUI in the model for easy color init
// however, this is not a best practice and should be avoided
import SwiftUI

// MARK: Progeress Ring Model and Sample Data
struct Ring: Identifiable {
  var id = UUID().uuidString
  var progress: CGFloat
  var value: String
  var keyIcon: String
  var keyColor: Color
  var isText: Bool = false
}

var rings: [Ring] = [
  Ring(progress: 72, value: "Steps", keyIcon: "figure.walk", keyColor: Color("Green")),
  Ring(progress: 36, value: "Calories", keyIcon: "flame.fill", keyColor: Color("Red")),
  Ring(progress: 91, value: "Sleep time", keyIcon: "😴", keyColor: Color("Purple"), isText: true)
]
