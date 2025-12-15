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
    ZStack {
      WaveformShape(samples: downsizedSamples)
    }
    .frame(maxWidth: .infinity)
    .onGeometryChange(for: CGSize.self) {
      $0.size
    } action: { newValue in
      initializeAudioFile(newValue)
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

/// Custom WaveForm Shape
fileprivate struct WaveformShape: Shape {
  var samples: [Float]
  var spacing: Float = 2
  var width: Float = 2
  
  nonisolated func path(in rect: CGRect) -> Path {
    Path { path in
      var x: CGFloat = 0
      for sample in samples {
        let height = max(CGFloat(sample) * rect.height, 1)
        
        path.addRect(
          CGRect(
            // below has the position at the top or something
            //origin: .init(x: x + CGFloat(width), y: 0),
            // lets position the samples at the center of the waveform view
            origin: .init(x: x + CGFloat(width), y: -height / 2),
            size: .init(width: CGFloat(width), height: height)
          )
        )
        
        x += CGFloat(spacing + width)
      }
    }
    .offsetBy(dx: 0, dy: rect.height / 2)
  }
}

extension WaveformScrubber {
  /// Audio Helpers
  // To Create audio waveforms we need audio samples. We can extract
  // audio samples form an audio file suing the AVKit framework.
  private func initializeAudioFile(_ size: CGSize) {
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
        //print(samples.count)
        
        let downSampleCount = Int(Float(size.width) / (config.spacing + config.shapeWidth))
        let downSamples = downSampleAudioSamples(samples, downSampleCount)
        //print(downSamples.count)
        await MainActor.run {
          self.samples = samples
          self.downsizedSamples = downSamples
          self.info(audioInfo)
        }
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
  
  nonisolated func downSampleAudioSamples(_ samples: [Float], _ count: Int) -> [Float] {
    let chunk = samples.count / count
    var downSamples: [Float] = []
    
    for index in 0..<count {
      let start = index * chunk
      let end = min((index + 1) * chunk, samples.count)
      let chunkSamples = samples[start..<end]
      
      let maxValue = chunkSamples.max() ?? 0
      downSamples.append(maxValue)
    }
    
    return downSamples
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
