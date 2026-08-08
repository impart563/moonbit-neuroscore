///|
pub fn gcs(eye : Int, verbal : Int, motor : Int) -> ScoreResult {
  ignore(score_input(label="eye", value=eye))
  ignore(score_input(label="verbal", value=verbal))
  ignore(score_input(label="motor", value=motor))
  if eye < 1 || eye > 4 {
    return incomplete("GCS", ["eye"], "Eye response must be 1..4")
  }
  if verbal < 1 || verbal > 5 {
    return incomplete("GCS", ["verbal"], "Verbal response must be 1..5")
  }
  if motor < 1 || motor > 6 {
    return incomplete("GCS", ["motor"], "Motor response must be 1..6")
  }
  let total = eye + verbal + motor
  let band = if total <= 8 {
    Severe
  } else if total <= 12 {
    High
  } else {
    Moderate
  }
  complete("GCS", total, band, "Eye + verbal + motor responses")
}
