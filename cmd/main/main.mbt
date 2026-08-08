///|
fn usage() -> Unit {
  println("neuroscore calc gcs EYE VERBAL MOTOR")
  println("neuroscore explain ich-score GCS AGE VOLUME IVH INFRATENTORIAL")
}

///|
fn parse_int(value : String) -> Int? {
  Some(@string.parse_int(value)) catch {
    _ => None
  }
}

///|
fn main {
  let args = @env.args()
  if args.length() < 2 {
    usage()
    return
  }
  match args[1:] {
    ["calc", "gcs", eye, verbal, motor] =>
      match parse_int(eye) {
        Some(e) =>
          match parse_int(verbal) {
            Some(v) =>
              match parse_int(motor) {
                Some(m) =>
                  println(
                    @neuroscore.score_result_json(@neuroscore.gcs(e, v, m)),
                  )
                None => usage()
              }
            None => usage()
          }
        None => usage()
      }
    ["explain", "ich-score", gcs, age, volume, ivh, infratentorial] =>
      match parse_int(gcs) {
        Some(g) =>
          match parse_int(age) {
            Some(a) =>
              match parse_int(volume) {
                Some(v) =>
                  match parse_int(ivh) {
                    Some(i) =>
                      match parse_int(infratentorial) {
                        Some(f) =>
                          println(
                            @neuroscore.score_result_json(
                              @neuroscore.ich_score(g, a, v, i, f),
                            ),
                          )
                        None => usage()
                      }
                    None => usage()
                  }
                None => usage()
              }
            None => usage()
          }
        None => usage()
      }
    _ => usage()
  }
}
