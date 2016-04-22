//
//  ViewController.swift
//  Bu
//
//  Created by Agustina Sanchez on 30/11/15.
//  Copyright © 2015 Quielin. All rights reserved.
//

import UIKit
import ZLSwipeableViewSwift
import Alamofire
import Cartography
import ReactiveUI
import SwiftyJSON

class ViewController: UIViewController, ExpandWordDelegate {
   
    var showingMenu = false
    var userId: Int?
    var sentence: Sentence?
    var swipeableView: ZLSwipeableView!
    var countSentence = 0
    var showingBack = false
    var flipedView: UIView?
    var translationSide: UIView?
    var definitionPanel: DefinitionPanel?
    
    var viewDefinition : UIView = UIView()
    var loadCardsFromXib = true
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let swipeableView =  swipeableView {
            swipeableView.nextView = {
                return self.nextCardView()
            }
        }
    }
    
    var layerDismissMenu = UIButton()
    
    @IBOutlet weak var progressButton: UIButton!
    @IBAction func menuClicked() {
        
        //hideWord()
        UIView.animateWithDuration(0.3, animations: {
            self.layerDismissMenu.removeFromSuperview()
            
            if self.showingMenu {
                self.showingMenu = false
                self.view.frame.origin.x -= 200
            }else {
                self.view.addSubview(self.layerDismissMenu)
                self.showingMenu = true
                self.view.frame.origin.x += 200
                
            }
        })
        //performSegueWithIdentifier("knownWords", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = false
        navigationController?.navigationBarHidden = true
        view.backgroundColor = UIColor.whiteColor()

        layerDismissMenu.frame = view.frame
        layerDismissMenu.addTarget(self, action: "menuClicked", forControlEvents: UIControlEvents.TouchUpInside)
        newUser()
    }
    
    func newUser() {
        //self.userId = 15
        //self.newSentence()
        Alamofire.request(.GET, "http://rest-buu.rhcloud.com/services/getNewUser")
            .responseJSON { response in
                if let json = response.result.value {
                    if let dictionaryUser = json as? NSDictionary {
                        self.userId = dictionaryUser["id"] as! Int
                        self.self.newSentence()
                    }
                }
        }
    }
    
    func newSentence() {
        Alamofire.request(.GET, "http://rest-buu.rhcloud.com/services/getNewSentence/\(userId!)")
            .responseJSON { response in
                if let json = response.result.value {
                    let jsonSentence = JSON(json)
                    self.sentence = Sentence(FromJSON: jsonSentence)
                    self.sentence?.display()
                    if self.swipeableView == nil {
                        self.loadCardStack()
                        self.newSentence()
                    } else {
                        if self.swipeableView.numberOfActiveView == 1 {
                            self.swipeableView.numberOfActiveView = 2
                        }
                    }
                }
        }
        print(userId!)
    }
    
    func loadCardStack() {
        swipeableView = ZLSwipeableView()
        swipeableView.frame = view.frame
        view.addSubview(swipeableView)
        swipeableView.numberOfActiveView = 1
        swipeableView.allowedDirection = .All
        constrain(swipeableView, view) { view1, view2 in
        view1.left == view2.left+20
        view1.right == view2.right-20
        view1.top == view2.top + 100
        view1.bottom == view2.bottom - 30
        }
        
        swipeableView.didSwipe = {view, location, vector in
            print("Did end swiping view at location: \(location)")
            if let card = view as? CardView {
                self.processSentence(card.sentence!.id, unknowWords: card.unknownWords)
            }
        }
        
        swipeableView.didStart = {view, location in
            print("Swiping at view location:")
            self.hideWord()
        }
        
        
        
    }
    
    // MARK: ()
    func nextCardView() -> UIView? {
        
        let cardView = CardView(frame: swipeableView.bounds, sentence: sentence)
        cardView.backgroundColor = UIColor.whiteColor()
        cardView.delegate = self
//        if loadCardsFromXib {
//            let contentView = NSBundle.mainBundle().loadNibNamed("CardContentView", owner: self, options: nil).first! as! CardView
//            contentView.translatesAutoresizingMaskIntoConstraints = false
//            contentView.backgroundColor = cardView.backgroundColor
//            cardView.addSubview(contentView)
//            if self.countSentence >= 2 {
//                if let sentence = self.sentence {
//                    let something = [NSFontAttributeName : UIFont.systemFontOfSize(35.0)]
//                    contentView.textView.attributedText = NSMutableAttributedString(string: sentence.display(), attributes: something)
// 
//                    newSentence()
//                }
//            }
//            self.countSentence++
//            constrain(contentView, cardView) { view1, view2 in
//                view1.left == view2.left
//                view1.top == view2.top
//                view1.width == cardView.bounds.width
//                view1.height == cardView.bounds.height
//            }
//        }
        return cardView
    }
    @IBAction func showTranslation() {
        
        //if let definitionPanel = definitionPanel {
            hideWord((swipeableView.topView() as! CardView).sentence!)
        //} else {
            //expandWord((swipeableView.topView() as! CardView).sentence!)
        //}
//        if (!showingBack) {
//            let firstCard = swipeableView.topView()! as! CardView
//            let front = firstCard.collectionView
//            let back = CardView(frame: swipeableView.bounds, sentence: nil)
//            translationSide = UIView(frame: CGRect(x: 10, y: 10, width: 1, height: 1))
//            back.addSubview(translationSide!)
//            back.backgroundColor = UIColor.whiteColor()
//            flipedView = front
//            UIView.transitionFromView(front!, toView: back, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
//            showingBack = true
//            
//        } else {
//            let front = translationSide!
////            translationSide = UIView(frame: CGRect(x: 10, y: 10, width: 1, height: 1))
////            front.addSubview(translationSide!)
//            let back = flipedView!
//            UIView.transitionFromView(front, toView: swipeableView.topView()!, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
//            showingBack = false
//        }
        
    }
    
    //MARK: finished Sentence
    func processSentence(idSentence: Int, unknowWords: Set<Int>) {
        var unknownWordsList = [Int]()
        for idUnknownWord in unknowWords {
            unknownWordsList.append(idUnknownWord)
        }
        
        Alamofire.request(.POST, "http://rest-buu.rhcloud.com/services/nextSentence", parameters: ["user" : userId!, "sentence" : idSentence, "unknowWords" : unknownWordsList], encoding: ParameterEncoding.JSON, headers: nil).responseJSON { response in
                if let json = response.result.value {
                    self.sentence = Sentence(FromJSON: JSON(json))
                    self.sentence?.display()
                }
        }
        print(userId!)
    }
        
    @IBOutlet weak var menuView: UIView!
    
    func expandWord(word: Word) {
        if let definitionPanel = definitionPanel {
            hideWord(word)
        }else {
            definitionPanel = NSBundle.mainBundle().loadNibNamed("DefinitionPanel", owner: self, options: nil).first! as! DefinitionPanel
            definitionPanel!.setup(word)
            definitionPanel?.delegate = self
            definitionPanel!.frame.size.width = view.frame.size.width
            
            definitionPanel?.definitionPanelText.sizeToFit()
            definitionPanel?.frame.size.height = definitionPanel!.definitionPanelText.frame.size.height + 200
            
            definitionPanel!.frame.origin.y = view.frame.size.height
            self.view.addSubview(definitionPanel!)
            
            UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { self.definitionPanel!.frame.origin.y = max(self.view.frame.size.height - 200,self.view.frame.size.height - self.definitionPanel!.frame.size.height + 200) }, completion: nil)
        }
    }
    
    @IBAction func progressClicked() {
        performSegueWithIdentifier("knownWords", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //navigationController?.setNavigationBarHidden(false, animated: true)
    }
    func expandWord(sentence: Sentence) {
        if let definitionPanel = definitionPanel {
            hideWord(sentence)
        }else {
            definitionPanel = NSBundle.mainBundle().loadNibNamed("DefinitionPanel", owner: self, options: nil).first! as! DefinitionPanel
            definitionPanel!.setup(sentence)
            definitionPanel?.delegate = self
            definitionPanel!.frame.size.width = view.frame.size.width
            
            definitionPanel?.definitionPanelText.sizeToFit()
            definitionPanel?.frame.size.height = definitionPanel!.definitionPanelText.frame.size.height + 200
            
            definitionPanel!.frame.origin.y = view.frame.size.height
            self.view.addSubview(definitionPanel!)
            
            UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { self.definitionPanel!.frame.origin.y = max(self.view.frame.size.height - 200,self.view.frame.size.height - self.definitionPanel!.frame.size.height + 200) }, completion: nil)
        }
    }
    
    func hideWord(word: Word?) {
        if let definitionPanel = definitionPanel {
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {definitionPanel.frame.origin.y = self.view.frame.size.height }, completion: {hola in
                definitionPanel.removeFromSuperview()
                self.definitionPanel = nil
                if word != nil { self.expandWord(word!) }
            })
            
        } else {
            if word != nil { self.expandWord(word!) }
        }
    }
    
    func hideWord(sentence: Sentence?) {
        if let definitionPanel = definitionPanel {
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {definitionPanel.frame.origin.y = self.view.frame.size.height }, completion: {hola in
                definitionPanel.removeFromSuperview()
                self.definitionPanel = nil
                if sentence != nil { self.expandWord(sentence!) }
            })
            
        } else {
            if sentence != nil { self.expandWord(sentence!)}
        }
    }
    
    func hideWord() {
        if let definitionPanel = definitionPanel {
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {definitionPanel.frame.origin.y = self.view.frame.size.height }, completion: {hola in
                definitionPanel.removeFromSuperview()
                self.definitionPanel = nil
            })
            
        }
    }

}

protocol ExpandWordDelegate {
    func expandWord(word: Word)
    func hideWord(word: Word?)
}

