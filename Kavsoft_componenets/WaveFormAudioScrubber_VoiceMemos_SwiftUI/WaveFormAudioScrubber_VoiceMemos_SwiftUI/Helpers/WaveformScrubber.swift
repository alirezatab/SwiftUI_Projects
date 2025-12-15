//
//  WaveformScrubber.swift
//  WaveFormAudioScrubber_VoiceMemos_SwiftUI
//
//  Created by ALIREZA TABRIZI on 12/14/25.
//

import SwiftUI
import AVKit

struct WaveformScrubber: View {
  
  var config: Config = .init()
  var url: URL
  /// scrubber progress
  @Binding var progres: CGFloat
  var info: (AudioInfo) -> () = { _ in }
  var onGestureActive: (Bool) -> () = { _ in }
  /// View Properties
  @State private var samples: [Float] = []
  @State private var downsizedSamples: [Float] = []
  
  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
      .onAppear {
        initializeAudioFile()
      }
  }
  
  struct Config {
    var spacing: Float = 2
    var shapeWidth: Float = 2
    var activeTint: Color = .black
    var inActiveTint: Color = .gray.opacity(0.7)
    /// OTHER CONFIGS....
  }
  
  struct AudioInfo {
    var duration: TimeInterval = 0
    /// OTHER AUDIO INFO....
  }
}

extension WaveformScrubber {
  /// Audio Helpers
  // To Create audio waveforms we need audio samples. We can extract
  // audio samples form an audio file suing the AVKit framework.
  
  private func initializeAudioFile() {
    guard samples.isEmpty else { return }
    
    Task.detached(priority: .high) {
      do {
        // this is how to extract info and sample count
        let audioFile = try AVAudioFile(forReading: url)
        let audioInfo = extractAudioInfo(audioFile)
        let samples = try extractAudioSamples(audioFile)
        
        // Sample count is very large and we dont want to display it in full.
        // This would lead to the app termination due to memory usage.
        // Therefore, we need to downsample it according to the width of the waveform scrubber so that we can actually display it.
        print(samples.count)
        
      } catch {
        print(error.localizedDescription)
      }
    }
    
  }
  
  nonisolated func extractAudioSamples(_ file: AVAudioFile) throws -> [Float] {
    let format = file.processingFormat
    let frameCount = UInt32(file.length)
    
    guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return [] }
    
    try file.read(into: buffer)
    
    if let channel = buffer.floatChannelData {
      let samples = Array(UnsafeBufferPointer(start: channel[0], count: Int(buffer.frameLength)))
      return samples
    }
    
    return []
  }
  
  nonisolated func extractAudioInfo(_ file: AVAudioFile) -> AudioInfo {
    let format = file.processingFormat
    let sampleRate = format.sampleRate
    
    let duration = file.length / Int64(sampleRate)
    
    return .init(duration: TimeInterval(duration))
  }
}

#Preview {
  //WaveformScrubber()
  ContentView()
}
