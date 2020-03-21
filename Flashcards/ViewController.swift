//
//  ViewController.swift
//  Flashcards
//
//  Created by Sumi Kolli on 2/28/20.
//  Copyright © 2020 Sumi Kolli. All rights reserved.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
}

class ViewController: UIViewController {

    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var card: UIView!
    
    var flashcards = [Flashcard]()
    var currentIndex = 0
    var isclick = true
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let navigationController = segue.destination as! UINavigationController

        let creationController = navigationController.topViewController as! CreationViewController

        creationController.flashcardsController = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        readSavedFlashcards()
        if flashcards.count == 0 {
            updateFlashcard(question: "What's the capital of Brazil?", answer: "Brasilia")
        }
        else {
            updateLabels()
            updateNextPrevButtons()
        }
    }
    
    @IBAction func didTapOnNext(_sender: Any) {
        currentIndex = currentIndex + 1
//        updateLabels()
        updateNextPrevButtons()
        isclick = true
        animateCardOut()
    }
    
    @IBAction func didTapOnPrev(_sender: Any) {
        currentIndex = currentIndex - 1
//        updateLabels()
        updateNextPrevButtons()
        isclick = false
        animateCardOut()
    }
    
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        flipFlashcard()
    }
    
    func flipFlashcard() {
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {
            if self.frontLabel.isHidden == false {
                self.frontLabel.isHidden = true;
            }
            else if self.frontLabel.isHidden == true {
                self.frontLabel.isHidden = false;
            }
        })
//        if frontLabel.isHidden == false {
//            frontLabel.isHidden = true;
//        }
//        else if frontLabel.isHidden == true {
//            frontLabel.isHidden = false;
//        }
    }
    func updateFlashcard(question: String, answer: String) {
        let flashcard = Flashcard(question: question, answer: answer)
//        frontLabel.text = flashcard.question
//        backLabel.text = flashcard.answer
        flashcards.append(flashcard)
        
        print("Added new flashcard")
        print("We now have \(flashcards.count) flashcards")
        currentIndex = flashcards.count - 1
        print("Our current index is \(currentIndex)")
        
        updateNextPrevButtons()
        updateLabels()
        
        saveAllFlashcardsToDisk()
    }
    
    func updateNextPrevButtons() {
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
        }
        else {
            nextButton.isEnabled = true
        }
        if currentIndex == 0 {
            prevButton.isEnabled = false
        }
        else {
            prevButton.isEnabled = true
        }
    }
    
    func animateCardOut() {
        if isclick {
            UIView.animate(withDuration: 0.3, animations: {
                self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
            }, completion: { finished in
                self.updateLabels()
                self.animateCardIn() })
        }
        else {
            UIView.animate(withDuration: 0.3, animations: {
                self.card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
            }, completion: { finished in
                self.updateLabels()
                self.animateCardIn() })
        }
    }
    
    func animateCardIn() {
        if isclick {
            card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
            UIView.animate(withDuration: 0.3) {
                self.card.transform = CGAffineTransform.identity
            }
        }
        else {
            card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
            UIView.animate(withDuration: 0.3) {
                self.card.transform = CGAffineTransform.identity
            }
        }
    }
    
    func updateLabels() {
        let currentFlashcard = flashcards[currentIndex]
        
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
    }
    
    func saveAllFlashcardsToDisk() {
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer": card.answer]
        }
        
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        print("Flashcards saved to UserDefaults")
    }
    
    func readSavedFlashcards() {
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]] {
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)}
            
            flashcards.append(contentsOf: savedCards)
        }
    }
}

