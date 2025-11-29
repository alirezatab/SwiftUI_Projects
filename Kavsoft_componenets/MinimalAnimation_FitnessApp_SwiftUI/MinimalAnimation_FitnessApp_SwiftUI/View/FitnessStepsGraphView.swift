//
//  FitnessStepsGraphView.swift
//  MinimalAnimation_FitnessApp_SwiftUI
//
//  Created by ALIREZA TABRIZI on 11/29/25.
//

import SwiftUI

struct FitnessStepsGraphView: View {
  var body: some View {
    VStack(spacing: 15) {
      Text("progress")
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      // Bar Graph
      // See Kavsof's Analytics App UI Video for bar graph Implementation
      // Link ...
      BarGraph(steps: steps)
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 25)
    .background {
      RoundedRectangle(cornerRadius: 25, style: .circular)
        .fill(.ultraThinMaterial)
    }
  }
}

#Preview {
  //FitnessStepsGraphView()
  ContentView()
}

// Modifying for our usage but can get the old implementation in another video
struct BarGraph: View {
  var steps: [Step]
  var body: some View {
    // GraphView
    GraphView()
      .padding(.top, 20)
  }
  
  @ViewBuilder
  func GraphView() -> some View {
    GeometryReader { proxy in
      
      ZStack {
      
        VStack(spacing: 0) {
          
          ForEach(getGraphLines(), id: \.self) { line in
            
            HStack(spacing: 8) {
              
              Text("\(Int(line))")
                .font(.caption)
                .foregroundStyle(.gray)
                .frame(height: 20)
              
              Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
            // Removing the text Size...
            .offset(y: -15)
          }
        }
        
        HStack {
          ForEach(steps.indices, id: \.self) { index in
            let step = steps[index]
            
            VStack(spacing: 0) {
              
              VStack(spacing: 5) {
                AnimatedBarGraph(step: steps[index], index: index)
              }
              .padding(.horizontal, 5)
              .frame(height: getBarHeight(point: step.value, size: proxy.size))
              
              Text(
                step.key
                  .replacingOccurrences(of: " AM", with: "")
                  .replacingOccurrences(of: " PM", with: "")
              )
                .font(.caption)
                .frame(height: 25, alignment: .bottom)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
          }
        }
        .padding(.leading, 30)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    // Fisxed Height
    .frame(height: 190)
  }
  
  func getGraphLines() -> [CGFloat] {
    let max = getMax()
    var lines: [CGFloat] = [ ]
    
    lines.append(max)
    
    for index in 1...4 {
      let progress = max / 4
      lines.append(max - (progress * CGFloat(index)))
    }
    
    return lines
  }
  
  func getBarHeight(point: CGFloat, size: CGSize) -> CGFloat {
    let max = getMax()
    
    // 25 Text Height
    // 5 spacing..
    let height = (point / max) * (size.height - 37)
    return height
  }
  
  // Getting Max...
  func getMax() -> CGFloat {
    let max = steps.max { first, second in
      return second.value > first.value
    }?.value ?? 0
    
    return max
  }
}

struct AnimatedBarGraph: View {
  
  let step: Step
  let index: Int
  @State var showBar = false
  
  var body: some View {
    VStack(spacing: 0)  {
      Spacer(minLength: 0)
      
      RoundedRectangle(cornerRadius: 5, style: .continuous)
        .fill(step.color)
        .frame(height: showBar ? nil : 0, alignment: .bottom)
    }
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8).delay(Double(index) * 0.1)) {
          showBar = true
        }
      }
    }
  }
}


