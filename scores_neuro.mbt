///|
pub fn mrs(stage : Int) -> ScoreResult {
  if stage < 0 || stage > 6 {
    return incomplete("mRS", ["stage"], "mRS must be 0..6")
  }
  let band = if stage <= 2 { Low } else if stage <= 4 { Moderate } else { High }
  complete("mRS", stage, band, "Ordinal modified Rankin Scale stage")
}

///|
pub fn hunt_hess(grade : Int) -> ScoreResult {
  if grade < 1 || grade > 5 {
    return incomplete("Hunt-Hess", ["grade"], "Hunt-Hess must be 1..5")
  }
  let band = if grade <= 2 { Low } else if grade <= 3 { Moderate } else { High }
  complete("Hunt-Hess", grade, band, "Clinical subarachnoid hemorrhage grade")
}

///|
pub fn wfns(grade : Int) -> ScoreResult {
  if grade < 1 || grade > 5 {
    return incomplete("WFNS", ["grade"], "WFNS must be 1..5")
  }
  let band = if grade <= 2 { Low } else if grade <= 3 { Moderate } else { High }
  complete(
    "WFNS", grade, band, "World Federation of Neurosurgical Societies grade",
  )
}

///|
pub fn modified_fisher(ct_grade : Int) -> ScoreResult {
  if ct_grade < 0 || ct_grade > 4 {
    return incomplete(
      "modified Fisher",
      ["ct_grade"],
      "modified Fisher must be 0..4",
    )
  }
  let band = if ct_grade <= 1 {
    Low
  } else if ct_grade == 2 {
    Moderate
  } else {
    High
  }
  complete("modified Fisher", ct_grade, band, "CT blood burden grade 0..4")
}

///|
pub fn ich_score(
  gcs_points : Int,
  age_points : Int,
  volume_points : Int,
  ivh_points : Int,
  infratentorial_points : Int,
) -> ScoreResult {
  let total = gcs_points +
    age_points +
    volume_points +
    ivh_points +
    infratentorial_points
  if total < 0 || total > 6 {
    return incomplete(
      "ICH Score",
      ["components"],
      "ICH component points produce a total of 0..6",
    )
  }
  let band = if total <= 1 { Low } else if total <= 3 { Moderate } else { High }
  complete(
    "ICH Score", total, band, "GCS, age, hematoma volume, IVH and infratentorial origin",
  )
}

///|
pub fn aspects(regions_involved : Int) -> ScoreResult {
  if regions_involved < 0 || regions_involved > 10 {
    return incomplete(
      "ASPECTS",
      ["regions_involved"],
      "ASPECTS affected regions must be 0..10",
    )
  }
  let total = 10 - regions_involved
  let band = if total >= 8 { Low } else if total >= 5 { Moderate } else { High }
  complete(
    "ASPECTS", total, band, "Ten-region CT record represented as unaffected-region score",
  )
}
