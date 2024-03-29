//
//  ContentView.swift
//  MusicPlayer
//
//  Created by Vemireddy Vijayasimha Reddy on 27/03/24.
//

import SwiftUI
import AVKit

struct ContentView: View {
    
    let audioFile = "piano"
    @State private var player: AVAudioPlayer?
    @State private var isPlaying = false
    @State private var totalTime: TimeInterval = 0.0
    @State private var currentTime: TimeInterval = 0.0
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    ButtonView(image: "arrow.left")
                    Spacer()
                    
                    ButtonView(image: "line.horizontal.3.decrease")
                }
                
                Text("Now Playing")
                    .fontWeight(.bold)
                    .foregroundColor(.black.opacity(0.8))
            }
            .padding(.all)
            Image("Skyview")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 55)
                .clipShape(Circle())
                .padding(.all, 8)
                .background(Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)))
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.35), radius: 8, x: 8, y: 8)
                .shadow(color: Color.white, radius: 10, x: -10, y: -10)
                .padding(.top, 35)
            Text("Draft")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black.opacity(0.8))
                .padding(.top, 25)
            Text("Robot koch ft nilu")
                .font(.caption)
                .foregroundStyle(.black.opacity(0.8))
                .padding(.top, 2)
            
            VStack {
                
                HStack {
                    Text(timeString(time: currentTime))
                    Spacer()
                    Text(timeString(time: totalTime))
                }
                .font(.caption)
                .foregroundStyle(.black.opacity(0.8))
                .padding([.top, .trailing, .leading ], 20)
                Slider(value: Binding(get: {
                    currentTime
                }, set: { newValue in
                    audioTimer(to: newValue)
                }), in: 0...totalTime)
                .padding([.top, .trailing, .leading], 20)
            }
            
            HStack(spacing: 20) {
                Button(action: {}, label: {
                    ButtonView(image: "backward.fill")
                })
                
                Button {} label: {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 14, weight: .bold))
                        .padding(.all, 25)
                        .foregroundStyle(.black.opacity(0.8))
                        .background(
                            ZStack{
                                Color(#colorLiteral(red: 0.760805, green: 0.8164, blue: 0.9259157777, alpha: 1))
                                Circle()
                                    .foregroundStyle(.white)
                                    .blur(radius: 4)
                                    .offset(x: -8, y: -8)
                                Circle()
                                    .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 231, green: 238, blue: 253), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .padding(2)
                                    .blur(radius: 2)
                                
                            }
                                .clipShape(Circle())
                                .shadow(color: Color(#colorLiteral(red: 0.760805, green: 0.8164, blue: 0.9259157777, alpha: 1)), radius: 20, x: 20, y: 20)
                                .shadow(color: Color.white, radius: 20, x: -20, y: -20)
                                .onTapGesture {
                                    isPlaying ? stopAudio() : playAudio()
                                }
                        )
                }
                Button(action: {}, label: {
                    ButtonView(image: "forward.fill")
                })
            }
            .padding(.top, 25)
            Spacer()
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)))
        .onAppear(perform: {
            setupAudio()
        })
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            updateProgress()
        }
    }
    
    private func setupAudio() {
        guard let url = Bundle.main.url(forResource: audioFile, withExtension: "mp3") else { return}
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            totalTime = player?.duration ?? 0.0
        } catch {
            print("error loading audio: \(error)")
        }
    }
    
    private func playAudio() {
        player?.play()
        isPlaying = true
    }
    
    private func stopAudio() {
        player?.stop()
        isPlaying = false
        
    }
    private func updateProgress() {
        guard let player = player else { return }
        currentTime = player.currentTime
        
    }
    private func audioTimer(to time: TimeInterval) {
        player?.currentTime = time
        
    }
    private func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ContentView()
}

struct ButtonView: View {
    
    var image: String
    
    var body: some View {
        Button(action: {}, label: {
            Image(systemName: image)
                .font(.system(size: 14, weight: .bold))
                .padding(.all, 25)
                .foregroundStyle(.black.opacity(0.8))
                .background(
                    ZStack{
                        Color(#colorLiteral(red: 0.760805, green: 0.8164, blue: 0.9259157777, alpha: 1))
                        Circle()
                            .foregroundStyle(.white)
                            .blur(radius: 4)
                            .offset(x: -8, y: -8)
                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 231, green: 238, blue: 253), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .padding(2)
                            .blur(radius: 2)
                        
                    }
                        .clipShape(Circle())
                        .shadow(color: Color(#colorLiteral(red: 0.760805, green: 0.8164, blue: 0.9259157777, alpha: 1)), radius: 20, x: 20, y: 20)
                        .shadow(color: Color.white, radius: 20, x: -20, y: -20)
                )
        })
    }
}
