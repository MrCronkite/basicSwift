


class MoveItem {
    var name: String
    init(name: String) {
        self.name = name
    }
}

class Song: MoveItem {
    var songList: String
    init(songList: String, name: String) {
        self.songList = songList
        super.init(name: name)
    }
}

class Movie: MoveItem {
    var moveList: String
    init(name: String, moveList: String) {
        self.moveList = moveList
        super.init(name: name)
    }
}


let library = [
    Movie(name: "Casablanca", moveList: "Michael Curtiz"),
    Song(songList: "Casablanca", name: "Blue Suede Shoes"),
    Movie(name: "Citizen Kane", moveList: "Orson Welles"),
    Song(songList: "Chesney Hawkes", name: "The One And Only"),
    Song(songList: "Rick Astley", name: "Never Gonna Give You Up")
]

var moveCount = 0
var songCount = 0

for item in library {
    if item is Movie {
        moveCount += 1
    } else if item is Song {
        songCount += 1
    }
}

print("В Media библиотеке содержится \(moveCount) фильма и \(songCount) песни")



struct BlackjackCard {
    
    enum Suit: Character {
        case spades = "♠", hearts = "♡", diamonds = "♢", clubs = "♣"
    }
    
}
