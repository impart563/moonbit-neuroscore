///|
/// The result of evaluating a named score through the registry.
pub struct EvaluationRecord {
  case_id : String
  scale : String
  result : ScoreResult?
  error : ScoreError?
} derive(Debug)

///|
pub fn evaluation_success(
  case_id~ : String,
  scale~ : String,
  result~ : ScoreResult,
) -> EvaluationRecord {
  { case_id, scale, result: Some(result), error: None }
}

///|
pub fn evaluation_failure(
  case_id~ : String,
  scale~ : String,
  error~ : ScoreError,
) -> EvaluationRecord {
  { case_id, scale, result: None, error: Some(error) }
}

///|
pub fn EvaluationRecord::is_success(self : EvaluationRecord) -> Bool {
  match self.result {
    Some(_) => true
    None => false
  }
}

///|
pub fn EvaluationRecord::summary(self : EvaluationRecord) -> String {
  match self.result {
    Some(result) => "\{self.scale}:\{result.total}:\{band_name(result.band)}"
    None =>
      match self.error {
        Some(error) => "\{self.scale}:error:\{score_error_code(error)}"
        None => "\{self.scale}:error:unknown"
      }
  }
}

///|
fn field_value(fields : Array[ScoreInput], label : String) -> Int? {
  for field in fields {
    if field.label == label {
      return Some(field.value)
    }
  }
  None
}

///|
fn require_field(
  fields : Array[ScoreInput],
  label : String,
) -> Int raise ScoreError {
  match field_value(fields, label) {
    Some(value) => value
    None => raise MissingField(label~)
  }
}

///|
/// Evaluate a supported scale using the same public calculators as direct callers.
pub fn evaluate_scale(
  case_id~ : String,
  scale~ : String,
  fields~ : Array[ScoreInput],
) -> EvaluationRecord {
  try {
    let result = match scale {
      "gcs" =>
        gcs(
          require_field(fields, "eye"),
          require_field(fields, "verbal"),
          require_field(fields, "motor"),
        )
      "mrs" => mrs(require_field(fields, "stage"))
      "hunt-hess" => hunt_hess(require_field(fields, "grade"))
      "wfns" => wfns(require_field(fields, "grade"))
      "modified-fisher" => modified_fisher(require_field(fields, "ct_grade"))
      "aspects" => aspects(require_field(fields, "regions_involved"))
      "ich-score" =>
        ich_score(
          require_field(fields, "gcs_points"),
          require_field(fields, "age_points"),
          require_field(fields, "volume_points"),
          require_field(fields, "ivh_points"),
          require_field(fields, "infratentorial_points"),
        )
      _ => raise UnknownScale(scale)
    }
    evaluation_success(case_id~, scale~, result~)
  } catch {
    error => evaluation_failure(case_id~, scale~, error~)
  }
}
