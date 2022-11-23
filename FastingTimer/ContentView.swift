//
//  ContentView.swift
//  FastingTimer
//
//  Created by rafiul hasan on 23/11/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var fastingManager = FastingManager()
    
    var title: String {
        switch fastingManager.fastingState {
        case .notStarted:
            return "Let's get started"
        case .fasting:
            return "You are now fasting"
        case .feeding:
            return "You are now feeding"
        }
    }
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.05024140328, green: 0.006751002744, blue: 0.08163713664, alpha: 1))
                .ignoresSafeArea()
            
            content
        }
    }
    
    var content: some View {
        ZStack {
            VStack(spacing: 40) {
                //MARK: Title
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color(#colorLiteral(red: 0.3843137255, green: 0.5176470588 , blue: 1, alpha: 1)))
                
                //MARK: Fasting Plan
                Text(fastingManager.fastingPlan.rawValue)
                    .fontWeight(.bold)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(.thinMaterial)
                    .cornerRadius(20)
                
                Spacer()
            }
            .padding()
            
            VStack(spacing: 40) {
                //MARK: Progress Ring
                ProgressRingView()
                    .environmentObject(fastingManager)
                
                HStack(spacing: 60) {
                    //MARK: Start timer
                    VStack(spacing: 5) {
                        Text(fastingManager.fastingState == .notStarted ? "Start" : "Started")
                            .opacity(0.7)
                        Text(fastingManager.startTime, format: .dateTime.weekday().hour().minute().second())
                    }
                    
                    //MARK: End timer
                    VStack(spacing: 5) {
                        Text(fastingManager.fastingState == .notStarted ? "End" : "Ends")
                            .opacity(0.7)
                        Text(fastingManager.endTime, format: .dateTime.weekday().hour().minute().second())
                    }
                }
                
                //MARK: Button
                Button {
                    fastingManager.toggleFastingState()
                } label: {
                    Text(fastingManager.fastingState == .fasting ? "End Fast" : "Start Fasting")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                }
            }
            .padding()
            .foregroundColor(.white)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
