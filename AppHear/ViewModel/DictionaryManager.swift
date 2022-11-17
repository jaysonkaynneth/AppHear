//
//  DictionaryManager.swift
//  AppHear
//
//  Created by Piter Wongso on 11/11/22.
//

import Foundation
import UIKit
import SwiftUI

class DictionaryManager : ObservableObject{

    @Published var word = [Word]()
    @Published var isFetching : Bool = true
    @Published var isSheetPresented = false
    @Published var tappedWord = ""
    @Published var confirmedText : AttributedString = ""
    @State var contohkalimat: AttributedString = AttributedString("")
    @State var transcript = ""
    
    func fetch(kata : String) {
        isFetching = true
        guard let url = URL(string:"https://new-kbbi-api.herokuapp.com/cari/\(kata)")else{
            return
        }
//        URLSession.shared
//            .dataTaskPublisher(for: url)
//            .flatMap(<#T##transform: ((data: Data, response: URLResponse)) -> Publisher##((data: Data, response: URLResponse)) -> Publisher#>)
//            .decode(type: Word.self, decoder: )
//            .sink { word in
//                self?.word = [Word]()
//                self?.word.append(decodedWord)
//            }
            
        let task = URLSession.shared.dataTask(with: url){[weak self]data, _, error in
            guard let data = data , error == nil else{
                return
            }
            do {
                let decodedWord = try
                JSONDecoder().decode(Word.self, from: data)
                DispatchQueue.main.async {
                    self?.word = [Word]()
                    self?.word.append(decodedWord)
                    self?.isFetching = false
                }
                
                
            }
            catch{
                print (error)
            }
        }
        task.resume()
    }
    func extractWord(location: CGPoint, transcript: String){
        let textContainer = NSTextContainer(size: CGSize(width:  290, height: 3000))
        let layoutManager = NSLayoutManager()
        let textStorage = NSTextStorage(attributedString: NSAttributedString(string: transcript))
        textStorage.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16) , range: NSMakeRange(0, NSAttributedString(string: transcript).length))
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        textContainer.lineBreakMode = .byWordWrapping
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = 0
        let indexChar = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        let firstPhase = transcript.substring(to:indexChar)
        let secondPhase = transcript.substring(from:indexChar)
        let firstIndex = firstPhase.lastIndexOfCharacter(" ") ?? 0
        let lastIndex = secondPhase.firstIndexOfCharacter(" ") ?? secondPhase.length
        tappedWord = transcript.substring(firstIndex..<lastIndex+indexChar).trimTrailingPunctuation()
        if !tappedWord.isEmpty && !tappedWord.isNumber{
            isSheetPresented.toggle()
        }
    }
    func highlightText(transcript: String){
        let transcriptWords = transcript.components(separatedBy: " ")
        
        for word in transcriptWords {
            
            let attributedString: AttributedString = AttributedString(word)
            var isMatched = false
            
            for searchw in VerbsList().kataDasar {
                var attributedWord: AttributedString = AttributedString(searchw)
                
                if word.contains(searchw) && word != searchw{
                    var container = AttributeContainer()
                    container.underlineStyle = .single
                    container.underlineColor = .blue
                    attributedWord.mergeAttributes(container)
                    let unhighlightedWord = word.replacingOccurrences(of: searchw, with: "/")
//                    var containerForEmpty = AttributeContainer()
                    let firstIndex = unhighlightedWord.firstIndexOfCharacter("/") ?? 0
                    let firstPhase = unhighlightedWord.substring(0..<firstIndex)
                    let secondPhase = unhighlightedWord.substring(from: firstIndex+1)
                    confirmedText += AttributedString(" ") + AttributedString(firstPhase) + attributedWord + AttributedString(secondPhase)
                    isMatched = true
                }
                
            }
            
            if isMatched == false{
                confirmedText += AttributedString(" ") + attributedString
            }
        }
    }
}

