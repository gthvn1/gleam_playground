import gleam/io
import gleam/list
import gleam/int

pub type Triplet =
  #(Int, Int, Int)

pub fn generate_triplet(m: Int, n: Int) -> Result(Triplet, String) {
  // Using Euclid's formula.
  case m > 1, m > n {
    False, _ -> Error("m must be greated than 2")
    _, True -> Ok(#(m * m - n * n, 2 * m * n, m * m + n * n))
    _, False -> Error("m must be greater than n")
  }
}

pub fn generate_triplets_for_m(m: Int) -> List(Triplet) {
  generate_triplets_loop(m, 1, list.new())
}

fn generate_triplets_loop(m: Int, n: Int, acc: List(Triplet)) -> List(Triplet) {
  // Generating
  //   generate_triplet(m, 1)
  //   generate_triplet(m, 2)
  // until
  //   generate_triplet(m, n) with m < n
  case m > n {
    False -> acc
    True ->
      case generate_triplet(m, n) {
        Ok(t) -> generate_triplets_loop(m, n + 1, [t, ..acc])
        Error(_) -> {
          io.debug("ERROR: m:" <> int.to_string(m) <> " n:" <> int.to_string(n))
          acc
        }
      }
  }
}

pub fn main() {
  generate_triplet(2, 1)
  |> io.debug

  generate_triplets_for_m(6)
  |> io.debug
}
