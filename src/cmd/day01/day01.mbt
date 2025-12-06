///|
fn main {
  run() catch {
    _ as err => {
      println("=== Error:")
      println(err)
      @sys.exit(1)
    }
  }
}

///|
fn run() -> Unit raise {
  let input = @fs.read_file_to_string("src/cmd/day01/input.txt")
  println("=== Day 01, part 1")
  println(part1(parse_file(input), start=Dial(50)))
  println("=== Day 01, part 2")
  println(part2(parse_file(input), start=Dial(50)))
}

///|
test "part1 example" {
  let turns = parse_file(
    (
      #|L68
      #|L30
      #|R48
      #|L5
      #|R60
      #|L55
      #|L1
      #|L99
      #|R14
      #|L82
    ),
  )
  inspect(part1(turns, start=Dial(50)), content="3")
}

///|
fn part1(turns : Array[Turn], start~ : Dial) -> Int {
  iter_dial(turns, start~)
  .filter(dial => match dial {
    Dial(0) => true
    _ => false
  })
  .count()
}

///|
fn iter_dial(turns : Array[Turn], start~ : Dial) -> Iter[Dial] {
  Iter::new(fn(visit : (Dial) -> IterResult) -> IterResult {
    let mut dial = start
    for turn in turns {
      dial = dial.turn(turn)
      guard visit(dial) is IterContinue else { break IterEnd }
    } else {
      IterContinue
    }
  })
}

///|
test "part2 example" {
  let turns = parse_file(
    (
      #|L68
      #|L30
      #|R48
      #|L5
      #|R60
      #|L55
      #|L1
      #|L99
      #|R14
      #|L82
    ),
  )
  inspect(part2(turns, start=Dial(50)), content="6")
}

///|
test "part2 all giving 1" {
  inspect(part2([Left(50), Right(50)], start=Dial(50)), content="1")
  inspect(part2([Left(50), Left(50)], start=Dial(50)), content="1")
  inspect(part2([Right(50), Left(50)], start=Dial(50)), content="1")
  inspect(part2([Right(50), Right(50)], start=Dial(50)), content="1")
}

///|
test "part2 all giving 2" {
  inspect(part2([Left(150), Left(50)], start=Dial(50)), content="2")
  inspect(part2([Left(150), Right(50)], start=Dial(50)), content="2")
  inspect(part2([Right(150), Left(50)], start=Dial(50)), content="2")
  inspect(part2([Right(150), Right(50)], start=Dial(50)), content="2")
}

///|
fn part2(turns : Array[Turn], start~ : Dial) -> Int {
  // because who doesn't like a bruteforce solution?
  let mut sum = 0
  for next in start.turn_multiple_steps(turns) {
    if next == 0 {
      sum += 1
    }
  }
  sum
}

///|
suberror ParseError String derive(Eq, Show)

///|
fn parse_file(file : String) -> Array[Turn] raise ParseError {
  let arr : Array[Turn] = Array::new()
  for line in file.split("\n") {
    guard line != "" else { continue }
    arr.push(parse_turn(line))
  }
  arr
}

///|
test "parse file" {
  inspect(
    parse_file(
      (
        #|L68
        #|L30
        #|R48
        #|L5
        #|R60
        #|L55
        #|L1
        #|L99
        #|R14
        #|L82
      ),
    ),
    content="[Left(68), Left(30), Right(48), Left(5), Right(60), Left(55), Left(1), Left(99), Right(14), Left(82)]",
  )
}
