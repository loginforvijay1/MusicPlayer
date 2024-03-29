//
//  PlayerNew.swift
//  MusicPlayer
//
//  Created by Vemireddy Vijayasimha Reddy on 28/03/24.
//

import SwiftUI
import AVFoundation

class AudioManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    @Published var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    @Published var currentTIme: TimeInterval = 0
    
    let audioFileName = "piano"
    
    init(audioPlayer: AVAudioPlayer? = nil, isPlaying: Bool = false, currentTIme: TimeInterval = 0) {
        super.init()
        self.audioPlayer = audioPlayer
        self.isPlaying = isPlaying
        self.currentTIme = currentTIme
        setupAudio()
        startTimer()
    }
    
    func setupAudio() {
        guard let audioFileURL = Bundle.main.url(forResource: audioFileName, withExtension: "mp3") else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.delegate = self
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    func playAudio() {
        audioPlayer?.play()
    }
    
    func pauseAudio() {
        audioPlayer?.pause()
    }
    
    func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval / 60)
        let seconds = Int(timeInterval.truncatingRemainder(dividingBy: 60))
        
        return String(format: "%02d:%02d", minutes, seconds)
        
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self , self.isPlaying else { return }
            
            self.currentTIme = self.audioPlayer?.currentTime ?? 0
            
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        currentTIme = 0
    }
}

struct PlayerNew: View {
    
    @StateObject private var audioManger = AudioManager()
    @State private var rotationAngle: Angle = .degrees(0)
    
    var body: some View {
        VStack {
            
            VStack {
                Text("Forest Sound")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .offset(y: 45)
                Text("Forest Sound")
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundStyle(Color.gray)
                    .offset(y: 45)
            }
            .background(
                Image("Skyview")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 301, height: 603)
                    .clipShape(
                        .rect(cornerRadii: RectangleCornerRadii(bottomLeading: 145, bottomTrailing: 145))))
            .shadow(color: .black, radius: 50, x: 0, y: 4)
            .padding(.bottom, 290)
            Text(audioManger.formatTime(audioManger.currentTIme))
                .font(Font.custom("Inter", size: 20).weight(.medium))
                .foregroundStyle(.black)
                .offset(y: 80)
            
            ZStack {
                Rectangle()
                    .foregroundStyle(.clear)
                    .frame(width: 220, height: 57)
                    .background(Color.white)
                    .cornerRadius(28.5)
                    .shadow(color: .black.opacity(0.4), radius: 44, x: 0, y: 4)
                VStack {
                    
                }
                .frame(width: 77, height: 77)
                .background(Color.black)
                .shadow(color: .black, radius: 50, x: 50, y: 4)
                .clipShape(Circle())
                
                Button {
                    if audioManger.isPlaying {
                        audioManger.audioPlayer?.pause()
                    } else {
                        audioManger.playAudio()
                    }
                    audioManger.isPlaying.toggle()
                } label: {
                    Image(systemName: audioManger.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 33))
                        .foregroundStyle(.white)
                }
                
                HStack {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "backward.fill")
                            .frame(width: 19, height: 19)
                            .foregroundStyle(.black)
                    })
                    .offset(x: -60)
                    
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "forward.fill")
                            .frame(width: 19, height: 19)
                            .foregroundStyle(.black)
                    })
                    .offset(x: 60)
                }
            }
            .offset(y: 110)
            
        }
    }
}

#Preview {
    PlayerNew()
}
