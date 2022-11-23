//
//  ProgressRingView.swift
//  FastingTimer
//
//  Created by rafiul hasan on 23/11/22.
//

import SwiftUI

struct ProgressRingView: View {
    @EnvironmentObject var fastingManager: FastingManager
    
    let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        ZStack {
            //MARK: Placeholder Ring
            Circle()
                .stroke(lineWidth: 20)
                .foregroundColor(.gray)
                .opacity(0.1)
            
            //MARK: Colored Ring
            Circle()
                .trim(from: 0.0, to: min(fastingManager.progress, 1.0))
                .stroke(AngularGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3351967931, green: 0.4746236205, blue: 0.995238483, alpha: 1)), Color(#colorLiteral(red: 0.9840623736, green: 0.3937336802, blue: 0.6762942672, alpha: 1)), Color(#colorLiteral(red: 0.8211885095, green: 0.6467975378, blue: 0.8108907342, alpha: 1)), Color(#colorLiteral(red: 0.5424887538, green: 0.8235172629, blue: 0.8577416539, alpha: 1)), Color(#colorLiteral(red: 0.3470519185, green: 0.4740032554, blue: 0.9873316884, alpha: 1))]), center: .center), style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                .rotationEffect(Angle(degrees: 270))
                .animation(.easeInOut(duration: 1.0), value: fastingManager.progress)
            
            VStack(spacing: 30) {
                if fastingManager.fastingState == .notStarted {
                    //MARK: Upcoming fast
                    VStack(spacing: 5) {
                        Text("Upcoming Time")
                            .opacity(0.7)
                        
                        Text("\(fastingManager.fastingPlan.fastingPeriod.formatted()) Hours")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                } else {
                    //MARK: Elapsed time
                    VStack(spacing: 5) {
                        Text("Elapsed Time \(fastingManager.progress.formatted(.percent))")
                            .opacity(0.7)
                        
                        Text(fastingManager.startTime, style: .timer)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    
                    //MARK: Remaining time
                    VStack(spacing: 5) {
                        if !fastingManager.elapsed {
                            Text("Remaining Time \((1-fastingManager.progress).formatted(.percent))")
                                .opacity(0.7)
                        } else {
                            Text("Extra Time")
                                .opacity(0.7)
                        }
                        
                        Text(fastingManager.endTime, style: .timer)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .frame(width: 250, height: 250)
        .padding()
        .onReceive(timer) { _ in
            fastingManager.track()
        }
    }
}

struct ProgressRingView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressRingView()
            .environmentObject(FastingManager())
    }
}
