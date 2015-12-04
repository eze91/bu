//
//  wordView.swift
//  Bu
//
//  Created by Agustina Sanchez on 3/12/15.
//  Copyright © 2015 Quielin. All rights reserved.
//

import UIKit

class WordView: UICollectionViewCell {
    
    let CHARACTER_WIDTH = 40
    let CELL_HEIGHT = CGFloat(65)
    
    @IBOutlet weak var selectedBarView: UIView!
    @IBOutlet weak var pinyinLabel: UILabel!
    @IBOutlet weak var hanziLabel: UILabel!
    
    var idWord: Int?
    var isPunctuation = false
    var isMarked = false {
        didSet{
            if isMarked {
                //selectedBarView.hidden = false
                UIView.animateWithDuration(0.3, animations: {
                    self.pinyinLabel.alpha = 1
                    self.selectedBarView.alpha = 1
                })
                //pinyinLabel.hidden = false
            } else {
                UIView.animateWithDuration(0.3, animations: {
                    self.pinyinLabel.alpha = 0
                    self.selectedBarView.alpha = 0
                })
                //selectedBarView.hidden = true
                //pinyinLabel.hidden = true
            }
        }
    }
    
    func setup(word: Word) {
        self.frame.size.width = CGFloat(CHARACTER_WIDTH * word.hanzi.characters.count)
        self.frame.size.height = CELL_HEIGHT
        pinyinLabel.text = word.pinyin
        hanziLabel.text = word.hanzi
        isMarked = false
        idWord = word.id
        isPunctuation = word.isPunctuation
    }

}
