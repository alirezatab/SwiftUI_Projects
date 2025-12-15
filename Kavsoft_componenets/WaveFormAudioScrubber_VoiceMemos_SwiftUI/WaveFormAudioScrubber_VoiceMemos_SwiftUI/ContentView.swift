//
//  ContentView.swift
//  WaveFormAudioScrubber_VoiceMemos_SwiftUI
//
//  Created by ALIREZA TABRIZI on 12/14/25.
//

import SwiftUI

struct ContentView: View {
  
  @State private var progress: CGFloat = 0
  
  var body: some View {
    NavigationStack {
      List {
        if let audioURL {
          Section("Borak_-_Le_Magistrat_(Original_Mix).aiff") {
            WaveformScrubber(url: audioURL, progres: $progress) { info in
              print(info.duration)
            } onGestureActive: { status in
              
            }
          }
        }
      }.navigationTitle("Waveform Scrubber")
    }
  }
  
  var audioURL: URL? {
    Bundle.main.url(forResource: "Borak_-_Le_Magistrat_(Original_Mix)", withExtension: "aiff")
  }
}

#Preview {
  ContentView()
}
