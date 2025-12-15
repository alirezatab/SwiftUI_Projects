//
//  ContentView.swift
//  WaveFormAudioScrubber_VoiceMemos_SwiftUI
//
//  Created by ALIREZA TABRIZI on 12/14/25.
//

import SwiftUI

struct ContentView: View {
  
  @State private var progress: CGFloat = 0.32
  @State private var duration: TimeInterval = 0
  @State private var isActive: Bool = false
  @Environment(\.colorScheme) var colorScheme
  
  var body: some View {
    NavigationStack {
      List {
        if let audioURL {
          Section("Borak_-_Le_Magistrat_(Original_Mix).aiff") {
            VStack(spacing: 6) {
              let config: WaveformScrubber.Config = .init(activeTint: colorScheme == .dark ? .white : .black)
              
              WaveformScrubber(config: config, url: audioURL, progress: $progress) { info in
                //print(info.duration)
                duration = info.duration
              } onGestureActive: { status in
                isActive = status
              }
              .frame(height: 60)
              .scaleEffect(y: isActive ? 0.75 : 0.5, anchor: .center)
              .animation(.bouncy, value: isActive)
              
              HStack {
                  Text(current)
                      .contentTransition(.numericText())
                      .animation(.snappy, value: progress)
                  
                  Spacer(minLength: 0)
                  
                  Text(end)
              }
              .monospaced()
              .font(.system(size: 14))
              .foregroundStyle(.gray)
              .padding(.horizontal, 10)
              .padding(.bottom, 5)
            }
            .listRowInsets(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
          }
        }
        
        Slider(value: $progress)
        
      }.navigationTitle("Waveform Scrubber")
    }
  }
  
  var current: String {
      let minutes = Int(duration * progress) / 60
      let seconds = Int(duration * progress) % 60
      return String(format: "%01d:%02d", minutes, seconds)
  }
  
  var end: String {
      let minutes = Int(duration) / 60
      let seconds = Int(duration) % 60
      return String(format: "%01d:%02d", minutes, seconds)
  }
  
  var audioURL: URL? {
    Bundle.main.url(forResource: "Borak_-_Le_Magistrat_(Original_Mix)", withExtension: "aiff")
  }
}

#Preview {
  ContentView()
}
