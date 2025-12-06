///|
struct Dial(Int) derive(Eq, Compare, Show, Default)

///|
struct TurnResult {
  dial : Dial
  overflows : Int
} derive(Eq, Show, Default)

///|
fn Dial::turn_left(self : Dial, count : Int) -> Dial {
  (self.0 - count + 100) % 100
}

///|
fn Dial::turn_right(self : Dial, count : Int) -> Dial {
  (self.0 + count) % 100
}

///|
fn Dial::turn(self : Dial, turn : Turn) -> Dial {
  match turn {
    Left(num) => self.turn_left(num)
    Right(num) => self.turn_right(num)
  }
}

///|
fn Dial::turn_right_steps(self : Dial, count : Int) -> Iter[Dial] {
  Iter::new(fn(visit : (Dial) -> IterResult) -> IterResult {
    let mut dial = self.0
    for _ in 0..<count {
      dial += 1
      if dial == 100 {
        dial = 0
      }
      guard visit(Dial(dial)) is IterContinue else { break IterEnd }
    } else {
      IterContinue
    }
  })
}

///|
fn Dial::turn_left_steps(self : Dial, count : Int) -> Iter[Dial] {
  Iter::new(fn(visit : (Dial) -> IterResult) -> IterResult {
    let mut dial = self.0
    for _ in 0..<count {
      dial -= 1
      if dial < 0 {
        dial = 99
      }
      guard visit(Dial(dial)) is IterContinue else { break IterEnd }
    } else {
      IterContinue
    }
  })
}

///|
fn Dial::turn_steps(self : Dial, turn : Turn) -> Iter[Dial] {
  match turn {
    Left(num) => self.turn_left_steps(num)
    Right(num) => self.turn_right_steps(num)
  }
}

///|
fn Dial::turn_multiple_steps(
  self : Dial,
  turns : ArrayView[Turn],
) -> Iter[Dial] {
  Iter::new(fn(visit : (Dial) -> IterResult) -> IterResult {
    let mut dial = self
    for turn in turns {
      for steps in dial.turn_steps(turn) {
        dial = steps
        guard visit(dial) is IterContinue else { return IterEnd }
      }
    } else {
      IterContinue
    }
  })
}

///|
test "turn dial" {
  inspect(Dial(11).turn_right(8), content="Dial(19)")
  inspect(Dial(19).turn_left(19), content="Dial(0)")
  inspect(Dial(0).turn_left(1), content="Dial(99)")
  inspect(Dial(99).turn_right(1), content="Dial(0)")
  inspect(Dial(5).turn_left(10), content="Dial(95)")
}

///|
test "turn dial steps" {
  inspect(
    Dial(11).turn_right_steps(8).map(x => x.0).collect(),
    content="[12, 13, 14, 15, 16, 17, 18, 19]",
  )
  inspect(
    Dial(95).turn_right_steps(10).map(x => x.0).collect(),
    content="[96, 97, 98, 99, 0, 1, 2, 3, 4, 5]",
  )
  inspect(
    Dial(5).turn_left_steps(10).map(x => x.0).collect(),
    content="[4, 3, 2, 1, 0, 99, 98, 97, 96, 95]",
  )
}

///|
test "turn dial multiple steps" {
  inspect(
    Dial(5).turn_multiple_steps([Left(10), Right(10)]).map(x => x.0).collect(),
    content="[4, 3, 2, 1, 0, 99, 98, 97, 96, 95, 96, 97, 98, 99, 0, 1, 2, 3, 4, 5]",
  )
}
