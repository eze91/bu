//
//  CardView.swift
//  ZLSwipeableViewSwiftDemo
//
//  Created by Zhixuan Lai on 5/24/15.
//  Copyright (c) 2015 Zhixuan Lai. All rights reserved.
//

import UIKit
import UICollectionViewLeftAlignedLayout

class CardView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    let CHARACTER_WIDTH = 40
    let CELL_HEIGHT = CGFloat(65)
    var lastWordIndex = -1
    
    var sentence : Sentence?
    var collectionView: UICollectionView?
    var unknownWords = Set<Int>()
    
    var delegate: ExpandWordDelegate?
    
    init(frame: CGRect, sentence: Sentence?) {
        super.init(frame: frame)
        setup()
        
        if let sentence = sentence {
            self.sentence = sentence
            collectionView = UICollectionView(frame: CGRect(origin: CGPoint(x: 20, y: 30), size: CGSize(width: self.frame.width - 40, height: self.frame.height - 50)), collectionViewLayout: UICollectionViewLeftAlignedLayout())
            collectionView?.delegate = self
            collectionView?.backgroundColor = UIColor.whiteColor()
            collectionView?.dataSource = self
            
            collectionView?.registerNib(UINib(nibName: "WordView", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "wordCellReuseIdentifier")
            self.addSubview(collectionView!)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        // Shadow
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.12
        layer.shadowOffset = CGSizeMake(0, 1.5)
        layer.shadowRadius = 5.0
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
        
        // Corner Radius
        layer.cornerRadius = 10.0;
    }
    
    //MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sentence!.words.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let returningCell = collectionView.dequeueReusableCellWithReuseIdentifier( "wordCellReuseIdentifier", forIndexPath: indexPath) as! WordView
        
        let wordToReturn = sentence!.words[indexPath.row]
        returningCell.setup(wordToReturn)
        return returningCell
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: CGFloat(sentence!.words[indexPath.row].hanzi.characters.count * CHARACTER_WIDTH),  height: CELL_HEIGHT)
    }
    
    //MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let touchedWordCell = collectionView.cellForItemAtIndexPath(indexPath) as! WordView
        
        if !touchedWordCell.isPunctuation {
            if touchedWordCell.isMarked && lastWordIndex != indexPath.row {
                
            } else {
                touchedWordCell.isMarked = !touchedWordCell.isMarked
                if touchedWordCell.isMarked {
                    unknownWords.insert(touchedWordCell.idWord!)
                } else {
                    unknownWords.remove(touchedWordCell.idWord!)
                    delegate?.hideWord(nil)
                    return
                }
            }
            print(unknownWords)
            delegate!.expandWord(sentence!.words[indexPath.row])
            lastWordIndex = indexPath.row
        }
    }
}
