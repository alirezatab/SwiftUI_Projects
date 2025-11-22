//
//  Home.swift
//  SpotifyRedesign_SwiftUI_Tutorial
//
//  Created by ALIREZA TABRIZI on 11/8/25.
//

import SwiftUI

struct Home: View {
  
  // Search Text...
  @State var searchText = ""
  
  var body: some View {
    // GeometryReader is a SwiftUI container that gives you the exact size and position of the space your view is given so you can build layouts that adapt dynamically.
    // You use GeometryReader only where a view needs to know its own available space
    /*
     Only when you want things like:
       •  “This view should be 30% of its parent width”
       •  “This sidebar should take half the screen height”
       •  “Position this circle exactly at the center”
       •  “Match the width of the container”
     
     */
    GeometryReader { proxy in
      
      HStack(spacing: 0) {
        
        SideTabView(proxy: proxy)
        
        // Main Content
        ScrollView {
          
          VStack(spacing: 15) {
            
            HStack(spacing: 15) {
              
              HStack(spacing: 15) {
                
                Circle()
                  .stroke(.white, lineWidth: 4)
                  .frame(width: 25, height: 25)
                
                TextField("Search...", text: $searchText)
              }
              .padding(.vertical, 10)
              .padding(.horizontal)
              .background(Color.white.opacity(0.08))
              .cornerRadius(8)
              
              Button(action: {}, label: {
                Image("profile")
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 45, height: 45)
                  .cornerRadius(10)
              })
            }
          }
          .padding()
          .frame(maxWidth: .infinity)
          
        }
        .scrollIndicators(.hidden)
      }
      .background(Color("bg").ignoresSafeArea())
    }
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

#Preview {
  Home()
}

// Extending View to get Screen Size...
extension View{
  // deprecated so used Geometry reader instead
  func getRect()->CGRect{
    return UIScreen.main.bounds
  }
  
  func getSafeArea() -> UIEdgeInsets {
    return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
}
