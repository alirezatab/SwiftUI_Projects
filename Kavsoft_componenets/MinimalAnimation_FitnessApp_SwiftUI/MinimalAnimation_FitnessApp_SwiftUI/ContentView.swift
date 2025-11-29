//
//  ContentView.swift
//  MinimalAnimation_FitnessApp_SwiftUI
//
//  Created by ALIREZA TABRIZI on 11/29/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
      ScrollView(.vertical) {
        Home()
      }
      .scrollIndicators(.hidden)
      .frame(maxWidth: .infinity)
      .background {
        ZStack {
          VStack {
            Circle()
              .fill(Color("Green"))
              .scaleEffect(0.6)
              .offset(x: 20)
              .blur(radius: 120)
            
            Circle()
              .fill(Color("Red"))
              .scaleEffect(0.6, anchor: .leading)
              .offset(y: -20)
              .blur(radius: 120)
          }
          
          Rectangle()
            .fill(.ultraThinMaterial)
        }
        .ignoresSafeArea()
      }
      .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
