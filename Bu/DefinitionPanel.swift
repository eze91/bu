//
//  DefinitionPanel.swift
//  Bu
//
//  Created by Agustina Sanchez on 5/12/15.
//  Copyright © 2015 Quielin. All rights reserved.
//

import UIKit

class DefinitionPanel: UIView {

    @IBOutlet weak var definitionPanelText: UITextView!
    var hidding = false
    var delegate: ExpandWordDelegate?
    var lastTranslationY = CGFloat(0)
    
    func setup(word: Word){


        var words = [word]
        var importanceMutiplayer = 1.0
        let individualWordText = NSMutableAttributedString(string: "")
        repeat {
            
            let actualWord = words.first!
            words.removeFirst()
            individualWordText.appendAttributedString(NSAttributedString(string: "\n", attributes: [NSFontAttributeName:UIFont.systemFontOfSize(CGFloat(importanceMutiplayer * 10))]))
            individualWordText.appendAttributedString(NSAttributedString(string: "\(actualWord.hanzi)", attributes: [NSFontAttributeName:UIFont.systemFontOfSize(CGFloat(importanceMutiplayer * 40))]))
            individualWordText.appendAttributedString(NSAttributedString(string: "   \(actualWord.pinyin)\n", attributes: [NSFontAttributeName : UIFont.systemFontOfSize(CGFloat(importanceMutiplayer * 20))]))
            individualWordText.appendAttributedString(NSAttributedString(string: "\n", attributes: [NSFontAttributeName:UIFont.systemFontOfSize(CGFloat(importanceMutiplayer * 10))]))
            if actualWord.definitionHere != nil && actualWord.definitionHere != "" {
                individualWordText.appendAttributedString(NSAttributedString(string: "\(actualWord.definitionHere!)\n", attributes: [NSFontAttributeName : UIFont.boldSystemFontOfSize(CGFloat(importanceMutiplayer * 20))]))
            }
            for var i = 0; i < actualWord.definitions.count; i++ {
                individualWordText.appendAttributedString(NSAttributedString(string: "\(actualWord.definitions[i])\n", attributes: [NSForegroundColorAttributeName:UIColor.grayColor(), NSFontAttributeName : UIFont.systemFontOfSize(CGFloat(importanceMutiplayer * 20))]))
            }
            for composedWord in actualWord.words {
                words.append(composedWord)
            }
            if false && importanceMutiplayer == 1.0 && !words.isEmpty{
                individualWordText.appendAttributedString(NSAttributedString(string: "\n\nComposed words\n", attributes: [NSFontAttributeName : UIFont.systemFontOfSize(CGFloat(importanceMutiplayer * 15)), NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue, NSForegroundColorAttributeName:UIColor.grayColor()]))
            } else {
            individualWordText.appendAttributedString(NSAttributedString(string: "\n\n", attributes: [NSFontAttributeName : UIFont.systemFontOfSize(CGFloat(importanceMutiplayer * 10))]))
            }
            definitionPanelText.attributedText = individualWordText
            importanceMutiplayer = 0.7
        } while !words.isEmpty
        
    }
    
    override func awakeFromNib() {
        let gesture = UIPanGestureRecognizer(target: self, action: "scrollView:")
        self.addGestureRecognizer(gesture)
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSizeMake(0, 1.5)
        layer.shadowRadius = 10.0
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
    }
    
    func setup(sentence: Sentence){
        var individualWordText = "Sorry. Translation no available."
        if let translation =  sentence.translation {
            individualWordText = "\(individualWordText)\n\n"
            definitionPanelText.attributedText = NSAttributedString(string: "\(translation)\n\n", attributes: [NSFontAttributeName : UIFont.systemFontOfSize(CGFloat(20))])
        }
        
        
    }
    
    func scrollView(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translationInView(self)
        print(translation.y)
        if recognizer.state == UIGestureRecognizerState.Ended && lastTranslationY > 10 && !hidding {
            hidding = true
            delegate!.hideWord(nil)
            return
        }
        lastTranslationY = translation.y
        if let view = recognizer.view {
            //GoUp
            if translation.y > 0 || frame.origin.y + frame.size.height - 200 > self.superview!.frame.size.height {
                view.center.y = view.center.y + translation.y
                    center.y = center.y + translation.y
            }
//            if translation.y > 0 || frame.origin.y + view.frame.size.height > frame.size.height {
//                view.center.y = view.center.y + translation.y
//                
//                if view.frame.origin.y + view.frame.size.height < self.frame.size.height {
//                    view.frame.origin.y = self.frame.size.height - view.frame.size.height
//                }
//            }
        }
        recognizer.setTranslation(CGPointZero, inView: self)
        
        }

}
