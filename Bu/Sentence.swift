
import Foundation
import SwiftyJSON

class Sentence {
    var id: Int
    var words: [Word]
    var translation: String?
    var level: String?
    var link: String?
    var topics = [String]()
    
    init(id: Int, words: [Word]){
        self.id = id
        self.words = words
    }
    
    convenience init(FromJSON json : JSON){
        let id = json["id"].intValue
        let wordsDef = json["wordsDef"].arrayValue
        var words = [Word](count: wordsDef.count, repeatedValue: Word(id: 0, hanzi: "", pinyin: "", words: [], definitions: [], position: 0))
        for jsonWord in wordsDef {
            let word = Word(FromJSON: jsonWord)
            words[word.position] = word
        }
        self.init(id: id, words: words)
        var topics = [String]()
        if let topicsJson = json["topics"].array {
            for jsonTopics in topicsJson {
                topics.append(jsonTopics.stringValue)
            }
        }
        self.topics = topics
        self.translation = json["translation"].string
        self.level = json["level"].string
    }
    
    func display() -> String {
        var partialSentence = ""
        for word in words{
            word.display()
            partialSentence = "\(partialSentence)\(word.display())"
        }
        return partialSentence
    }
}