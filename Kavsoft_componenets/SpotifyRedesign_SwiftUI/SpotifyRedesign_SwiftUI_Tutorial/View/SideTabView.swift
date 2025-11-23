//
//  SideTabView.swift
//  SpotifyRedesign_SwiftUI_Tutorial
//
//  Created by ALIREZA TABRIZI on 11/8/25.
//

import SwiftUI

struct SideTabView: View {
  
  // Storing current Tab..
  @State var selectedTab = "house.fill"
  
  // Volume
  @State var volume: CGFloat = 0.4
  @State var showSideBar = false
  
  var proxy: GeometryProxy
  
  var body: some View {
    // SideBar Tab Bar
    // Optimizing for smaller size iphone...
    VStack {
      Image("spotify")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 45, height: 45)
        .padding(.top)
      
      VStack {
        TabButton(image: "house.fill", selectedTab: $selectedTab)
        TabButton(image: "safari.fill", selectedTab: $selectedTab)
        TabButton(image: "mic.fill", selectedTab: $selectedTab)
        TabButton(image: "clock.fill", selectedTab: $selectedTab)
      }
      // setting the tabs for half of the height so that remanining element will get space...
      .frame(height: proxy.size.height / 2.3)
      .padding(.top)
      
      Spacer(minLength: proxy.size.height < 750 ? 30 : 50)
      
      Button(action: {
        // checking and increasing volume...
        volume = volume + 0.1 < 1.0 ? volume + 0.1 : 1
      }, label: {
        Image(systemName: "speaker.wave.2.fill")
          .font(.title2)
          .foregroundStyle(.white)
      })
      
      // ✅ It is NOT measuring the whole screen
      // ✅ It is NOT measuring the whole sidebar
      // ✅ It is ONLY measuring the vertical space BETWEEN the buttons
      
      // Custom Volume progress View
      GeometryReader { proxy in
        
        // extracting progress bar height and based on that getting progress value...
        let height = proxy.frame(in: .global).height
        let progress = height * volume
        
        ZStack(alignment: .bottom) {
          
          Capsule()
            .fill(.gray.opacity(0.5))
            .frame(width: 4)
          
          Capsule()
            .fill(.white)
            .frame(width: 4, height: progress)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
      }
      .padding(.vertical, proxy.size.height < 75 ? 15 : 20)
      
      Button(action: {
        // checking and decreasing volume...
        volume = volume - 0.1 > 0 ? volume -  0.1 : 0
      }, label: {
        Image(systemName: "speaker.wave.1.fill")
          .font(.title2)
          .foregroundStyle(.white)
      })
      
      Button(action: {
        withAnimation(.easeIn) {
          showSideBar.toggle()
        }
      }, label: {
        Image(systemName: "chevron.right")
          .font(.title2)
          .foregroundStyle(.white)
        // rotating ...
          .rotationEffect(.init(degrees: showSideBar ? -180 : 0))
          .padding()
          .background(.black)
          .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
          .shadow(radius: 5)
      })
      .padding(.top, proxy.size.height < 75 ? 10 : 30)
      .padding(.bottom, proxy.safeAreaInsets.bottom == 0 ? 15 : 0)
      .offset(x: showSideBar ? 0 : 100)
    }
    // max side Bar width
    .frame(width: 80)
    .background(Color.black.ignoresSafeArea())
    .offset(x: showSideBar ? 0 : -80)
    // reclaiming the spacing by using negatve spacing...
    // if you want to move the along with tab bar .. Dont comment below code
    .padding(.trailing, showSideBar ? 0 : -100)
    
    // changing the stack position
    // so that the side bar will be on top...
    .zIndex(1)
  }
}

struct TabButton: View {
  var image: String
  @Binding var selectedTab: String
  
  var body: some View {
      Button(action: {
        withAnimation { selectedTab = image }
      }, label: {
        Image(systemName: image)
          .font(.title)
          .foregroundStyle(
            selectedTab == image
            ? .white
            : .gray.opacity(0.6))
          .frame(maxHeight: .infinity)
      })
  }
}

// Extending View to get Screen Size...
// deprecated
/*
extension View {
  // deprecated so used Geometry reader instead
  func getRect()->CGRect{
    return UIScreen.main.bounds
  }
  
  func getSafeArea() -> UIEdgeInsets {
    return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
}
*/

extension View {
  /// Modern SwiftUI-safe way to get screen size (no UIScreen)
  func screenSize(_ proxy: GeometryProxy) -> CGSize {
      proxy.size
  }

  /// Modern SwiftUI-safe way to get safe area insets
  func safeArea(_ proxy: GeometryProxy) -> EdgeInsets {
      proxy.safeAreaInsets
  }
}

#Preview {
  GeometryReader { proxy in
    Home(proxy: proxy)
      .preferredColorScheme(.dark)
  }
  // SideTabView()
}
