///|
struct Dial(Int) derive(Eq, Compare, Show, Default)

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
test "turn dial" {
  inspect(Dial(11).turn_right(8), content="Dial(19)")
  inspect(Dial(19).turn_left(19), content="Dial(0)")
  inspect(Dial(0).turn_left(1), content="Dial(99)")
  inspect(Dial(99).turn_right(1), content="Dial(0)")
  inspect(Dial(5).turn_left(10), content="Dial(95)")
}
