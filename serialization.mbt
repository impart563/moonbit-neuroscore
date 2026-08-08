///|
pub fn score_result_json(result : ScoreResult) -> String {
  let missing = result.missing.map(fn(item) { "\"\{item}\"" }).join(",")
  "{\"name\":\"\{result.name}\",\"total\":\{result.total},\"band\":\"\{band_name(result.band)}\",\"missing\":[\{missing}],\"explanation\":\"\{result.explanation}\"}"
}

///|
pub fn band_name(band : RiskBand) -> String {
  match band {
    Low => "low"
    Moderate => "moderate"
    High => "high"
    Severe => "severe"
    NotApplicable => "not_applicable"
  }
}
