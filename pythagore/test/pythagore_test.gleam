import gleeunit
import gleeunit/should
import pythagore
import gleam/result

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn generate_triplet_2_1_test() {
  pythagore.generate_triplet(2, 1)
  |> result.unwrap(#(0, 0, 0))
  |> should.equal(#(3, 4, 5))
}
