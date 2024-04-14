import gleeunit
import gleeunit/should
import hello

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_myadd_test() {
  hello.myadd(10, 32)
  |> should.equal(42)
}

pub fn hello_world_test() {
  1
  |> should.equal(1)
}
