let game = Game()
let controller = TextViewController(game: game)

while true {
    controller.makeMove(input())
}
