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

///|
test "structured errors retain transport context" {
  let error : ScoreError = InvalidColumn(
    row=4,
    column="motor",
    reason="not an integer",
  )
  assert_eq(score_error_code(error), "invalid_column")
  assert_true(score_error_message(error).contains("motor"))
  assert_eq(score_error_code(ScoreError::UnknownScale("new")), "unknown_scale")
  assert_eq(score_error_code(ScoreError::EmptyInput), "empty_input")
}

///|
test "case identifiers and audit events are deterministic" {
  let id = case_id(suite="gcs-boundary", number=7)
  assert_eq(id.to_string(), "gcs-boundary-7")
  let event = audit_event(
    sequence=2,
    kind=EvaluationCompleted,
    scale="gcs",
    case_id=id.to_string(),
    detail="total=15",
  )
  assert_eq(event.kind_name(), "evaluation_completed")
  assert_true(event.to_json().contains("gcs-boundary-7"))
}

///|
test "registry dispatch preserves direct calculator semantics" {
  let fields = [
    score_input(label="eye", value=4),
    score_input(label="verbal", value=5),
    score_input(label="motor", value=6),
  ]
  let record = evaluate_scale(case_id="case-1", scale="gcs", fields~)
  assert_true(record.is_success())
  assert_eq(record.summary(), "gcs:15:moderate")
  let unknown = evaluate_scale(case_id="case-2", scale="new", fields=[])
  assert_true(unknown.error is Some(UnknownScale("new")))
}

///|
test "registry reports missing fields without coercion" {
  let record = evaluate_scale(case_id="case-3", scale="ich-score", fields=[
    score_input(label="gcs_points", value=1),
  ])
  assert_true(record.result is None)
  assert_true(record.error is Some(MissingField(label="age_points")))
}
