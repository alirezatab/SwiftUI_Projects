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
      
      Spacer(minLength: 50)
      
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
      .padding(.vertical, 20)
      
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
          .cornerRadius(10)
          .shadow(radius: 5)
      })
      .padding(.top, 30)
      .padding(.bottom, proxy.safeAreaInsets.bottom == 0 ? 15 : 0)
      .offset(x: showSideBar ? 0 : 100)
    }
    // max side Bar width
    .frame(width: 80)
    .background(Color.black.ignoresSafeArea())
    .offset(x: showSideBar ? 0 : -100)
    // reclaiming the spacing by using negatve spacing...
    // if you want to move the along with tab bar .. Dont comment below code
    .padding(.trailing, showSideBar ? 0 : -100)
    
    // changing the stack position
    // so that the side bar will be on top...
    .zIndex(1)
  }
}


#Preview {
  Home()
  // SideTabView()
}
