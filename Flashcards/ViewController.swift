//
//  ViewController.swift
//  Flashcards
//
//  Created by Sumi Kolli on 2/28/20.
//  Copyright © 2020 Sumi Kolli. All rights reserved.
//

import UIKit
//flashcard struct
struct Flashcard {
    var question: String
    var answer: String
}
//overall class
class ViewController: UIViewController {
    //outlets for labels and buttons
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var card: UIView!
    //array of flashcards
    var flashcards = [Flashcard]()
    var currentIndex = 0
    var isclick = true
    //called automatically on the viewcontroller that is presenting
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let navigationController = segue.destination as! UINavigationController

        let creationController = navigationController.topViewController as! CreationViewController

        creationController.flashcardsController = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //reads Disk of saved flashcards
        readSavedFlashcards()
        //if there are no saved flashcards on Disk
        if flashcards.count == 0 {
            updateFlashcard(question: "What's the capital of Brazil?", answer: "Brasilia")
        }
        else {
            updateLabels()
            updateNextPrevButtons()
        }
    }
    //update flashcard shown when next button is tapped
    @IBAction func didTapOnNext(_sender: Any) {
        currentIndex = currentIndex + 1
//        updateLabels()
        //update indexing of buttons
        updateNextPrevButtons()
        isclick = true
        //animation transition
        animateCardOut()
    }
    //update flashcard shown when prev button is tapped
    @IBAction func didTapOnPrev(_sender: Any) {
        currentIndex = currentIndex - 1
//        updateLabels()
        //update indexing of buttons
        updateNextPrevButtons()
        isclick = false
        //animation transition
        animateCardOut()
    }
    //call animation for flipping
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        flipFlashcard()
    }
    //animation for flashcard flipping
    func flipFlashcard() {
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {
            if self.frontLabel.isHidden == false {
                self.frontLabel.isHidden = true;
            }
            else if self.frontLabel.isHidden == true {
                self.frontLabel.isHidden = false;
            }
        })
    }
    //update strings on flashcards of question and answer
    func updateFlashcard(question: String, answer: String) {
        let flashcard = Flashcard(question: question, answer: answer)
//        frontLabel.text = flashcard.question
//        backLabel.text = flashcard.answer
        flashcards.append(flashcard)
        //for debugging
        print("Added new flashcard")
        print("We now have \(flashcards.count) flashcards")
        currentIndex = flashcards.count - 1
        print("Our current index is \(currentIndex)")
        //update labels and buttons
        updateNextPrevButtons()
        updateLabels()
        //save new flashcard to disk
        saveAllFlashcardsToDisk()
    }
    //enable or disable next and prev buttons if first or last flashcard
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
    //animation for animating card out
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
    //animation for animating card in
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
    //update labels on flashcard based on index in array
    func updateLabels() {
        let currentFlashcard = flashcards[currentIndex]
        
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
    }
    //save to Disk by converting array of Flashcard to array of dictionaries with keys as questions and answers strings
    func saveAllFlashcardsToDisk() {
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer": card.answer]
        }
        
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        print("Flashcards saved to UserDefaults")
    }
    //read Disk whenever app is reopened
    func readSavedFlashcards() {
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]] {
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)}
            
            flashcards.append(contentsOf: savedCards)
        }
    }
}

