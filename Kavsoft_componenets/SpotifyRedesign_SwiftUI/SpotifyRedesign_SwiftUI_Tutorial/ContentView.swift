//
//  ContentView.swift
//  SpotifyRedesign_SwiftUI_Tutorial
//
//  Created by ALIREZA TABRIZI on 11/8/25.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    GeometryReader { proxy in
      Home(proxy: proxy)
      // always dark mode...
        .preferredColorScheme(.dark)
    }
  }
}

#Preview {
  ContentView()
}
