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
  
  @State var animatedValue: CGFloat = 55
  
  @State var maxWidth = UIScreen.main.bounds.width / 2.2
  
  @State var time: Float = 0
  
  var body: some View {
    VStack {
      
      HStack {
        VStack(alignment: .leading, spacing: 8) {
          Text(album.title)
            .fontWeight(.semibold)
          
          HStack(spacing: 10) {
            Text(album.artist)
              .font(.caption)
            
            Text(album.type)
              .font(.caption)
          }
        }
        
        Spacer(minLength: 0)
        
        Button(action: {}) {
          Image(systemName: "suit.heart.fill")
            .foregroundStyle(.red)
            .frame(width: 45, height: 45)
            .background(Color.white)
            .clipShape(Circle())
        }
        
        Button(action: {}) {
          Image(systemName: "bookmark.fill")
            .foregroundStyle(.black)
            .frame(width: 45, height: 45)
            .background(Color.white)
            .clipShape(Circle())
        }
        .padding(.leading, 10)
      }
      .padding()
      
      Spacer(minLength: 0)
      
      if album.artwork.count != 0 {
        Image(uiImage: UIImage(data: album.artwork)!)
          .resizable()
          .frame(width: 250, height: 250)
          .clipShape(RoundedRectangle(cornerRadius: 15))
        //.cornerRadius(15)
      }
      
      ZStack {
        
        ZStack {
          Circle()
            .fill(Color.white.opacity(0.2))
          
          Circle()
            .fill(Color.white.opacity(0.15))
            .frame(width: animatedValue / 2, height: animatedValue / 2)
        }
        .frame(width: animatedValue, height: animatedValue)
        
        Button(action: play) {
          Image(systemName: album.isPlaying ? "pause.fill" : "play.fill")
            .foregroundStyle(.black)
            .frame(width: 55, height: 55)
            .background(Color.white)
            .clipShape(Circle())
        }
      }
      .frame(width: maxWidth, height: maxWidth   )
      .padding(.top, 30)
      
      // Audio Tracking...
      Slider(value: Binding(get: {time}, set: { (newValue) in
      
        time = newValue
        
        // updating player...
        audioPlayer.currentTime = Double(time) * audioPlayer.duration
        audioPlayer.play()
      }))
      .padding()
      
      Spacer(minLength: 0)
    }
    .onReceive(timer) { (_) in
      if audioPlayer.isPlaying {
        
        audioPlayer.updateMeters()
        album.isPlaying = true
        // update slider...
        time = Float(audioPlayer.currentTime / audioPlayer.duration)
        
        // getting animations...
        startAnimation()
        //print(audioPlayer.currentTime)
        
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
    
    audioPlayer.isMeteringEnabled = true
    
    // extracting audio data...
    
    let asset = AVAsset(url: audioPlayer.url!)
    
    asset.metadata.forEach { (meta) in
      switch(meta.commonKey?.rawValue) {
        // "albumName"
        // "format"
        // "identifier"
        // "subject"
        // "publisher"
      case "artwork":
        album.artwork = meta.value == nil ? UIImage(named: "any sample pic...")!.pngData()! : meta.value as! Data
      case "artist": album.artist = meta.value == nil ? "" : meta.value as! String
      case "type": album.type = meta.value == nil ? "" : meta.value as! String
      case "title": album.title = meta.value == nil ? "" : meta.value as! String
      default: ()
      }
    }
  }
  
  func startAnimation() {
    // getting levels...
    var power: Float = 0
    for i in 0..<audioPlayer.numberOfChannels {
      //print("averagePower \(audioPlayer.averagePower(forChannel: i))")
      power += audioPlayer.averagePower(forChannel: i)
      //print(power) -> comes a as negative values
      
      // calculation to get postive number...
      let value = max(0, power + 55) // this 50 is cause of the frame / width and hight of the play button
      // you can also use if st to find positive number...
      
      let animated = CGFloat(value) * (maxWidth / 55)
      
      withAnimation(Animation.linear(duration: 0.01)) {
        self.animatedValue = animated
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
