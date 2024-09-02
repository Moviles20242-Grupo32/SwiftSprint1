//
//  ContentView.swift
//  Test14
//
//  Created by Daniela Uribe on 1/09/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var name : String = ""
    @State private var synthesizer: AVSpeechSynthesizer?
    var body: some View {
        VStack {
            TextField("Name", text:$name)
            Button("Greet"){
                speak()
            }
        }
        .padding()
    }
    
    func speak() {
            
            let audioSession = AVAudioSession() // 2) handle audio session first, before trying to read the text
            do {
                try audioSession.setCategory(.playback, mode: .default, options: .duckOthers)
                try audioSession.setActive(false)
            } catch let error {
                print("❓", error.localizedDescription)
            }
            
            synthesizer = AVSpeechSynthesizer()
            
            let speechUtterance = AVSpeechUtterance(string: "Hola \(name)")
            speechUtterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
            
            synthesizer?.speak(speechUtterance)
        }
}

#Preview {
    ContentView()
}
