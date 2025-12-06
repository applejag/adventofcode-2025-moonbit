///|
pub fn sum(data : Iter[Int]) -> Int {
  let mut result : Int = 0
  for n in data {
    result += n
  }
  result
}
