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
  @State private var errorTitle = ""
  @State private var errorMessage = ""
  @State private var showingError = false
  
  func addNewWord(){
    let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    
    guard answer.count > 0 else {
      return
    }
    guard isOriginal(word: answer) else {
        wordError(title: "Word used already", message: "Be more original")
        return
    }

    guard isPossible(word: answer) else {
        wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
        return
    }

    guard isReal(word: answer) else {
        wordError(title: "Word not possible", message: "That isn't a real word.")
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
  
  func isOriginal(word: String) -> Bool {
    !usedWords.contains(word)
  }
  
  func isPossible(word: String) -> Bool {
    var tempWord = rootword
    
    for letter in word {
      if let pos = tempWord.firstIndex(of: letter){
        tempWord.remove(at: pos)
      } else {
        return false
      }
    }
    return true
  }
  
  func isReal(word: String) -> Bool {
    let checker = UITextChecker()
    let rang = NSRange(location: 0, length: word.utf16.count)
    let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: rang, startingAt: 0, wrap: false, language: "en")
    
    return misspelledRange.location == NSNotFound
  }
  
  func wordError(title: String, message : String) {
    errorTitle = title
    errorMessage = message
    showingError = true
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
    .alert(isPresented: $showingError) {
      Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("ok")))
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
