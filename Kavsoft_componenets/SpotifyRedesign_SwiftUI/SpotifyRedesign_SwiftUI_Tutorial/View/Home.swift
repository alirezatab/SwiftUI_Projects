//
//  Home.swift
//  SpotifyRedesign_SwiftUI_Tutorial
//
//  Created by ALIREZA TABRIZI on 11/8/25.
//

import SwiftUI

struct Home: View {
  
  var proxy: GeometryProxy
  // Search Text...
  @State var searchText = ""
  
  var body: some View {
    // GeometryReader is a SwiftUI container that gives you the exact size and position of the space your view is given so you can build layouts that adapt dynamically.
    // You use GeometryReader only where a view needs to know its own available space
    // it is best used when the parent has a fixed size or you fix the parrent size based on height and width
    /*
     Only when you want things like:
       •  “This view should be 30% of its parent width”
       •  “This sidebar should take half the screen height”
       •  “Position this circle exactly at the center”
       •  “Match the width of the container”
     */
      
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
            .background(Color.white.opacity(0.06))
            .cornerRadius(8)
            
            Button(action: {}, label: {
              Image("profile")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 45, height: 45)
                .cornerRadius(10)
            })
          }
          
          Text("Recently Played")
            .font(.title)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 30)
          
          // Carousel List...
          TabView {
            
            ForEach(recentlyPlayed) { item in
              
              GeometryReader { TabProxy in
                
                ZStack(alignment: .bottomLeading) {
                  
                  Image(item.albumCover)
                    .resizable()
                  // from Tutorial: if you are using fill, then you must specify width...
                    .aspectRatio(contentMode: .fill)
                    .frame(width: TabProxy.size.width, height: TabProxy.size.height)
                    .cornerRadius(20)
                  // Dark shading at bottom so that the data will be visible...
                    .overlay(
                      LinearGradient(
                        gradient: .init(colors: [.clear, .clear, .black]),
                        startPoint: .top,
                        endPoint: .bottom)
                      .cornerRadius(20)
                    )
                  
                  
                  HStack(spacing: 15) {
                    Button(action: {}, label: {
                      
                      // Play Button..
                      Image(systemName: "play.fill")
                        .font(.title )
                        .foregroundStyle(.white)
                        .padding(20)
                        .background(Color("logoColor"))
                        .clipShape(Circle())
                    })
                    
                    VStack(alignment: .leading, spacing: 5) {
                      Text(item.albumName)
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundStyle(.white)
                      
                      Text(item.albumAuthor)
                        .font(.none)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    }
                  }
                  .padding()
                }
              }
              .padding(.horizontal)
              .frame(height: 350)
            }
          }
          // max Frame...
          .frame(height: 350)
          .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
          .padding(.top, 20)
          
          Text("Genres")
            .font(.title)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 30)
          
          LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3),
            spacing: 20, content: {
              // List of Genres
              ForEach(generes, id: \.self) { genre in
                
                Text(genre)
                  .fontWeight(.semibold)
                  .foregroundStyle(.white)
                  .padding(.vertical, 8)
                  .frame(maxWidth: .infinity)
                  .background(.white.opacity(0.06))
                  .clipShape(Capsule())
              }
            })
          .padding(.top, 20)
          
          Text("Liked Songs")
            .font(.title)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 30)
          
          LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2),
            spacing: 10, content: {
              
              // Liked Songs
              ForEach(likedSongs.indices, id: \.self) { index in
                
                GeometryReader { proxy in
                  
                  Image(likedSongs[index].albumCover)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.frame(in: .global).width, height: 150)
                  //.cornerRadius(10)
                  // based on index number were changing the corner style...
                    .clipShape(
                      CustomerCorners(
                        corners: index % 2 == 0 ? [.topLeft, .bottomLeft] : [.topRight, .bottomRight],
                        radius: 15
                      )
                    )
                }
                .frame(height: 150)
              }
            })
          .padding(.horizontal)
          .padding(.top, 20)
        }
        .padding()
        .frame(maxWidth: .infinity)
      }
      .scrollIndicators(.hidden)
    }
    .background(Color("bg").ignoresSafeArea())
  }
}

#Preview {
  GeometryReader { proxy in
    Home(proxy: proxy)
      .preferredColorScheme(.dark)
  }
  // SideTabView()
}

// custom corner for Single Side corner Image...
struct CustomerCorners: Shape {
  var corners: UIRectCorner
  var radius: CGFloat
  
  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius))
    
    return Path(path.cgPath)
  }
}
