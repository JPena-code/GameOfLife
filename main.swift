import Swift

class Cell: CustomStringConvertible {
  let x: Int
  let y: Int
  let state: Bool

  init(x: Int, y: Int, state: Bool){
    self.x = x
    self.y = y
    self.state = state
  }

  var description : String { return "x: \(self.x), y \(self.y), state: \(self.state)"}

  func getX() -> Int {return self.x}

  func getY() -> Int {return self.y}

  func getState() -> Bool {return self.state}
}

func near(x: Int, y: Int) -> Int {
  var near_cells: Int = 0
  if(board[(14 + y) % 15][(x + 19) % 20]){
    // Exquina Izquierda Superior
    near_cells += 1
  } 
  if(board[y % 15][(19 + x) % 20]){  
    // Izquierda
    near_cells += 1
  } 
  if(board[(y + 16) % 15][(19 + x) % 20]){
    // Esquina Izquierda Inferior
    near_cells += 1
  } 
  if(board[(14 + y) % 15][x % 20]){
    // Arriba
    near_cells += 1
  } 
  if(board[y % 15][(x + 1) % 20]){
    // Derecha
    near_cells += 1
  } 
  if(board[(y + 14) % 15][(21 + x) % 20]){
    // Esquina Derecha Superior
    near_cells += 1
  } 
  if(board[(y + 1) % 15][x % 20]){
    // Abajo
    near_cells += 1
  } 
  if(board[(y + 1) % 15][(x + 1) % 20]){
    // Esquina Derecha Inferior
    near_cells += 1
  }
  return near_cells
}

var board = Array(repeating: Array(repeating: false, count: 20), count: 15)
var cells: [Cell] = []
print("Selecione un patron:", "(1) Still life", "(2) Gridel", "(3) Blinker", separator: "\n")
let pattern = readLine()!
switch pattern {
  case "1":
    board[7][8] = true
    board[6][8] = true
    board[7][9] = true
    board[6][10] = true
    board[5][10] = true
    board[5][9] = true
  case "2":
    board[7][8] = true
    board[8][9] = true
    board[9][9] = true
    board[8][10] = true
    board[7][10] = true
  case "3":
    board[8][8] = true
    board[8][9] = true
    board[8][10] = true
    board[7][9] = true
  default:
    print("Eso no esta en la lista")
}

print("Ingrese el numero de iteraciones: ")
var iter = Int(readLine()!) ?? 0

for i in 0...iter {
  print("\u{001B}[0;37mIteracon No. \(i)")
  // Comprobar los vecinos de cada celula
  for y in 0...14 {
    for x in 0...19 {
      let near_cells = near(x: x, y: y)
      if near_cells == 3 && !board[y][x] {
        // Regla 1 una celula nace si tiene tres cerca
        let aux: Cell = Cell(x: x, y: y, state: true)
        cells.append(aux)
      } else if board[y][x] && (near_cells < 2 || near_cells > 3) {
        // Regla 2 una celula muere si tiene menos de 2 o mas de 3 cerca
        let aux: Cell = Cell(x: x, y: y, state: false)
        cells.append(aux)
      }
      // Regla 3 deja la celula viva entonces no se hace nada
      //"\u{001B}[0;32mO"
      // "\u{001B}[0;31mx"
      let to = board[y][x] ?  "🟢 " : "❌ "
      print(to, terminator: " ")
    }
    print("\n")
  }
  // Revisa si hay alguna celula por actualizar 
  while(!cells.isEmpty) {
    let cell: Cell = cells.removeFirst()
    board[cell.getY()][cell.getX()] = cell.getState()
  }
}