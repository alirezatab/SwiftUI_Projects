//
//  ContentView.swift
//  CustomAudioPlayerWithAudioVisualizer_SwiftUI
//
//  Created by ALIREZA TABRIZI on 12/15/25.
//

import SwiftUI
import AVKit
import Combine

struct ContentView: View {
  var body: some View {
    NavigationStack {
      Home()
        .navigationTitle("")
        .toolbar(.hidden, for: .navigationBar)
        .preferredColorScheme(.dark)
    }
  }
}

#Preview {
  ContentView()
}

struct Home: View {
  
  @State var audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
  
  // Timer to find current Time of audio...
  @State var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
  // Details of song...
  @StateObject var album = album_Data()
  
  var body: some View {
    VStack {
      
      if album.artwork.count != 0 {
        Image(uiImage: UIImage(data: album.artwork)!)
          .resizable()
          .frame(width: 250, height: 250)
          .clipShape(RoundedRectangle(cornerRadius: 15))
          //.cornerRadius(15)
      }
      
      Button(action: play) {
        Image(systemName: album.isPlaying ? "pause.fill" : "play.fill")
          .foregroundStyle(.black)
          .frame(width: 55, height: 55)
          .background(Color.white)
          .clipShape(Circle())
      }
      .padding(.top, 25)
    }
    .onReceive(timer) { (_) in
      if audioPlayer.isPlaying {
        album.isPlaying = true
        print(audioPlayer.currentTime)
      } else {
        album.isPlaying = false
      }
    }
    .onAppear(perform: getAudioData)
  }
  
  func play() {
    if audioPlayer.isPlaying {
      audioPlayer.pause()
    } else {
      audioPlayer.play()
    }
    
  }
  
  func getAudioData() {
    // extracting audio data...
    
    let asset = AVAsset(url: audioPlayer.url!)
    
    asset.metadata.forEach { (meta) in
      switch(meta.commonKey?.rawValue) {
      case "artwork":
        album.artwork = meta.value == nil ? UIImage(named: "any sample pic...")!.pngData()! : meta.value as! Data
      case "artist": album.artist = meta.value == nil ? "" : meta.value as! String
      case "type": album.type = meta.value == nil ? "" : meta.value as! String
      case "title": album.title = meta.value == nil ? "" : meta.value as! String
      default: ()
      }
    }
  }
}

let url = Bundle.main.path(forResource: "audio", ofType: ".aiff")

class album_Data: ObservableObject {
  @Published var isPlaying = false
  @Published var title = ""
  @Published var artist = ""
  @Published var artwork = Data(count: 0)
  @Published var type = ""
}
