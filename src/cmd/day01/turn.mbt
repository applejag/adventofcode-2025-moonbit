///|
enum Turn {
  Right(Int)
  Left(Int)
} derive(Eq, Compare, Show)

///|
fn parse_turn(str : StringView) -> Turn raise ParseError {
  fn parse_num(num : StringView, err_prefix : String) -> Int raise ParseError {
    let parsed = @strconv.parse_int(num, base=10) catch {
      @strconv.StrConvError(s) => raise ParseError(err_prefix + s)
    }
    guard parsed > 0 else {
      raise ParseError(err_prefix + "must be 1 or higher")
    }
    parsed
  }

  match str {
    ['L', .. num] => Turn::Left(parse_num(num, "parse L: "))
    ['R', .. num] => Turn::Right(parse_num(num, "parse R: "))
    _ => raise ParseError("turn must start with L or R")
  }
}

///|
test "parse turns" {
  inspect(parse_turn("L1"), content="Left(1)")
  inspect(parse_turn("L10"), content="Left(10)")
  inspect(parse_turn("L829"), content="Left(829)")
  inspect(parse_turn("R1"), content="Right(1)")
  inspect(parse_turn("R10"), content="Right(10)")
  inspect(parse_turn("R631"), content="Right(631)")
}

///|
test "parse invalid turns" {
  inspect(
    try? parse_turn("L0"),
    content=(
      #|Err(ParseError("parse L: must be 1 or higher"))
    ),
  )
  inspect(
    try? parse_turn("R0"),
    content=(
      #|Err(ParseError("parse R: must be 1 or higher"))
    ),
  )
  inspect(
    try? parse_turn("L-10"),
    content=(
      #|Err(ParseError("parse L: must be 1 or higher"))
    ),
  )
  inspect(
    try? parse_turn("R-10"),
    content=(
      #|Err(ParseError("parse R: must be 1 or higher"))
    ),
  )
  inspect(
    try? parse_turn("foo"),
    content=(
      #|Err(ParseError("turn must start with L or R"))
    ),
  )
}
