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

///|
test "all ordinal scales reject both sides of their input domain" {
  assert_eq(mrs(-1).band, NotApplicable)
  assert_eq(mrs(7).band, NotApplicable)
  assert_eq(hunt_hess(0).band, NotApplicable)
  assert_eq(hunt_hess(6).band, NotApplicable)
  assert_eq(wfns(0).band, NotApplicable)
  assert_eq(wfns(6).band, NotApplicable)
  assert_eq(modified_fisher(-1).band, NotApplicable)
  assert_eq(modified_fisher(5).band, NotApplicable)
  assert_eq(aspects(-1).band, NotApplicable)
  assert_eq(aspects(11).band, NotApplicable)
}

///|
test "gcs validates every component independently" {
  assert_eq(gcs(0, 1, 1).missing, ["eye"])
  assert_eq(gcs(1, 0, 1).missing, ["verbal"])
  assert_eq(gcs(1, 1, 0).missing, ["motor"])
  assert_eq(gcs(4, 5, 6).total, 15)
  assert_eq(gcs(1, 1, 1).total, 3)
}

///|
test "ich score rejects totals outside the published aggregate range" {
  assert_eq(ich_score(-1, 0, 0, 0, 0).band, NotApplicable)
  assert_eq(ich_score(7, 0, 0, 0, 0).band, NotApplicable)
  assert_eq(ich_score(1, 1, 1, 1, 1).total, 5)
}

///|
test "catalog is stable and supports safe lookup" {
  assert_eq(scale_catalog().length(), 7)
  assert_eq(scale_descriptor("gcs").unwrap().maximum, 15)
  assert_true(scale_descriptor("unknown") is None)
}
