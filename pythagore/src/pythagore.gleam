import gleam/io
import gleam/list
import gleam/int
import gleam/set

pub type Triplet =
  #(Int, Int, Int)

pub fn generate_triplet(m: Int, n: Int) -> Result(Triplet, String) {
  // Using Euclid's formula.
  //   -> a = 2*m*n, b = m^2 - n^2, c = m^2 + n ^2
  // Condition: m > n >= 1
  case m >= 2, n >= 1, m > n {
    False, _, _ -> Error("m must be greater than 2")
    _, False, _ -> Error("n must be greater than 1")
    _, _, False -> Error("m must be greater than n")
    _, _, _ -> {
      // We want a < b < c
      let a = 2 * m * n
      let b = m * m - n * n
      let c = m * m + n * n
      case a < b {
        True -> Ok(#(a, b, c))
        False -> Ok(#(b, a, c))
      }
    }
  }
}

// Generating all triplets for a given m.
// That means:
//   generate_triplet(m, 1)
//   generate_triplet(m, 2)
//   ...
//   generate_triplet(m, n) with m < n
pub fn generate_triplets_for_m(m: Int) -> List(Triplet) {
  generate_triplets_loop(m, 1, list.new())
}

fn generate_triplets_loop(m: Int, n: Int, acc: List(Triplet)) -> List(Triplet) {
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

// Generates triplets until the sum is reached
// AS a + b + c = 2*m^2 + 2*m*n we can roughly stop when square root
// of sum is reached. We are generating more values but that's fine.
pub fn generate_triplets_for_sum(sum: Int) -> List(Triplet) {
  case int.square_root(sum) {
    Ok(v) -> generate_triplets_for_sum_loop(v, 2, list.new())
    Error(_) -> list.new()
  }
}

fn generate_triplets_for_sum_loop(
  limit: Float,
  m: Int,
  acc: List(Triplet),
) -> List(Triplet) {
  let new_triplets = generate_triplets_for_m(m)
  case int.to_float(m) >=. limit {
    True -> acc
    False ->
      generate_triplets_for_sum_loop(
        limit,
        m + 1,
        list.append(acc, new_triplets),
      )
  }
}

// Found all triplets for which a + b + c = sum
// As we are using primitive triplets we also check for multiples
pub fn found_triplets(sum: Int) -> List(Triplet) {
  generate_triplets_for_sum(sum)
  |> list.filter(fn(t) { sum % { t.0 + t.1 + t.2 } == 0 })
  |> list.map(fn(t) {
    let factor = sum / { t.0 + t.1 + t.2 }
    #(t.0 * factor, t.1 * factor, t.2 * factor)
  })
  |> set.from_list
  |> set.to_list
}

pub fn main() {
  generate_triplet(2, 1)
  |> io.debug

  generate_triplets_for_m(6)
  |> io.debug
  |> list.map(fn(t) {
    let #(a, b, c) = t
    #(t, a + b + c)
  })
  |> io.debug

  generate_triplets_for_sum(1000)
  |> io.debug

  found_triplets(840)
  |> io.debug
}
