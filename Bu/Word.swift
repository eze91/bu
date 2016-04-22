
import Foundation
import SwiftyJSON

class Word {
    var isPunctuation = false
    var id: Int
    var hanzi: String
    var pinyin: String
    var position: Int
    var definitionHere: String?
    var definitions = [String]()
    var words = [Word]()
    var link: String?
    var difficulty: String?
    var topics = [String]()
    
    init(id: Int, hanzi: String, pinyin: String, words: [Word], definitions : [String], position: Int){
        self.id = id
        self.hanzi = hanzi
        self.pinyin = pinyin
        self.words = words
        self.definitions = definitions
        self.position = position
    }
    
    convenience init(var FromJSON json : JSON){
        
        var definitionHere = json["here"].string
        let position = json["position"].intValue
        json = json["word"]
        if json != nil {
            //word
            let id = json["id"].intValue
            let hanzi = json["hanzi"].stringValue
            let pinyin = json["pinyin"].stringValue
            var unorderedWords = [Word]()
            for jsonWord in json["hasWords"].arrayValue {
                unorderedWords.append(Word(FromJSON: jsonWord))
            }
            var words = [Word](count: unorderedWords.count, repeatedValue: Word(id: 0, hanzi: "", pinyin: "", words: [], definitions: [], position: 0))
            
            for unorderedWord in unorderedWords {
                words[unorderedWord.position] = unorderedWord
            }
            var definitions = [String]()
            
            if json["definition"].arrayValue.count > 1 {
                for jsonDefiniiton in json["definition"].arrayValue {
                    if !jsonDefiniiton.stringValue.hasPrefix(definitionHere!) {
                        definitions.append(jsonDefiniiton.stringValue)
                    }
                }
            } else {
                definitionHere = json["definition"].arrayValue[0].stringValue
            }
            
            self.init(id: id, hanzi: hanzi, pinyin: pinyin, words: words, definitions : definitions, position: position)
            
            var topics = [String]()
            if let jsonTopics = json["topics"].array {
                for jsonTopics in jsonTopics {
                    topics.append(jsonTopics.stringValue)
                }
            }
            self.topics = topics
            difficulty = json["difficulty"].string
            link = json["link"].string
            self.definitionHere = definitionHere
        } else {
            //punctuation
            self.init(id: 0, hanzi: definitionHere!, pinyin: "", words: [], definitions : [], position: position)
            isPunctuation = true
        }
    }
    
    func display() -> String {
        print(self.hanzi)
        return self.hanzi
    }

}