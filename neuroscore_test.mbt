///|
test "gcs totals three components and classifies severe injury" {
  let result = gcs(3, 1, 1)
  assert_eq(result.total, 5)
  assert_eq(result.band, Severe)
  assert_eq(result.evidence.length(), 1)
}

///|
test "invalid inputs are explicit and do not look like clinical scores" {
  let result = gcs(0, 5, 6)
  assert_eq(result.band, NotApplicable)
  assert_eq(result.missing.length(), 1)
  assert_true(result.explanation.contains("1..4"))
}

///|
test "common neurosurgical scales preserve their published ordinal totals" {
  assert_eq(mrs(2).total, 2)
  assert_eq(hunt_hess(4).total, 4)
  assert_eq(wfns(3).total, 3)
  assert_eq(modified_fisher(3).total, 3)
  assert_eq(ich_score(1, 1, 1, 1, 0).total, 4)
  assert_eq(aspects(2).total, 8)
}
