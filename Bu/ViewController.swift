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

class ViewController: UIViewController {

    var userId: Int?
    var sentence: Sentence?
    var swipeableView: ZLSwipeableView!
    var countSentence = 0
    
    var loadCardsFromXib = true
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        swipeableView.nextView = {
            return self.nextCardView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = true
        view.backgroundColor = UIColor.whiteColor()
        view.clipsToBounds = true
        
        let titleImage = UIImageView(image: UIImage(named: "5050"))
        titleImage.frame.origin.x = 20
        titleImage.frame.origin.y = 30
        titleImage.userInteractionEnabled = true
        
        self.view.addSubview(titleImage)
        
        swipeableView = ZLSwipeableView()
        swipeableView.frame = view.frame
        view.addSubview(swipeableView)
        swipeableView.numberOfActiveView = 2
        swipeableView.allowedDirection = .All
        constrain(swipeableView, view) { view1, view2 in
            view1.left == view2.left+20
            view1.right == view2.right-20
            view1.top == view2.top + 100
            view1.bottom == view2.bottom - 30
        }
        
        swipeableView.didEnd = {view, location in
            print("Did end swiping view at location: \(location)")
        }
        
        newUser()
    }
    
    func newUser() {
        self.userId = 15
        self.newSentence()
//        Alamofire.request(.GET, "http://rest-buu.rhcloud.com/services/getNewUser")
//            .responseJSON { response in
//                if let json = response.result.value {
//                    if let dictionaryUser = json as? NSDictionary {
//                        self.userId = dictionaryUser["id"] as! Int
//                        self.newUserHandler()
//                    }
//                }
//        }
    }
    
    func newSentence() {
        Alamofire.request(.GET, "http://rest-buu.rhcloud.com/services/getNewSentence/\(userId!)")
            .responseJSON { response in
                if let json = response.result.value {
                    self.sentence = Sentence(FromJSON: JSON(json))
                    self.sentence?.display()
                }
        }
        print(userId!)
    }
    
    func newSentenceHandler(sentenceJSON: JSON) {
        
    }
    
    // MARK: ()
    func nextCardView() -> UIView? {
        
        let cardView = CardView(frame: swipeableView.bounds, sentence: sentence)
        newSentence()
        cardView.backgroundColor = UIColor.whiteColor()
        
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
}

