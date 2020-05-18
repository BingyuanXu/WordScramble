//
//  ContentView.swift
//  WordScramble
//
//  Created by bingyuan xu on 2020-05-13.
//  Copyright © 2020 bingyuan xu. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  @State private var usedWords = [String]()
  @State private var rootword = ""
  @State private var newWord = ""
  
  func addNewWord(){
    let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    
    guard answer.count > 0 else {
      return
    }
    
    usedWords.insert(answer, at: 0)
    newWord = ""
  }
  
  func startGame (){
    if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
      if let startWords = try? String(contentsOf: startWordsURL) {
        let allWords = startWords.components(separatedBy: "\n")
        rootword = allWords.randomElement() ?? "silkworm"
        
        return
        
      }
    }
    
    fatalError("Could not load start.txt from bundle.")
  }
  
  var body: some View {
    NavigationView {
      VStack{
        TextField("Enter your word",text: $newWord, onCommit: addNewWord)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .keyboardType(UIKeyboardType.alphabet)
          .autocapitalization(.none)
          .padding()
        
        List(usedWords, id: \.self){
          Image(systemName: "\($0.count).circle.fill")
          Text($0)
        }
      }
      .padding()
      .navigationBarTitle(rootword)
    }
  .onAppear(perform: startGame)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
