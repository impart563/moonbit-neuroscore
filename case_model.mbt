///|
/// A stable identifier for a synthetic or integration test case.
pub struct CaseId {
  suite : String
  number : Int
} derive(Debug, Eq)

///|
pub fn case_id(suite~ : String, number~ : Int) -> CaseId {
  { suite, number }
}

///|
pub fn CaseId::to_string(self : CaseId) -> String {
  "\{self.suite}-\{self.number}"
}

///|
pub struct ScoreCase {
  id : CaseId
  scale : String
  fields : Array[ScoreInput]
  expected_total : Int?
  expected_band : RiskBand?
  note : String
} derive(Debug, Eq)

///|
pub fn score_case(
  id~ : CaseId,
  scale~ : String,
  fields~ : Array[ScoreInput],
  expected_total? : Int,
  expected_band? : RiskBand,
  note~ : String,
) -> ScoreCase {
  { id, scale, fields, expected_total, expected_band, note }
}

///|
pub fn ScoreCase::is_expected(self : ScoreCase, result : ScoreResult) -> Bool {
  let total_ok = match self.expected_total {
    Some(total) => result.total == total
    None => true
  }
  let band_ok = match self.expected_band {
    Some(band) => result.band == band
    None => true
  }
  total_ok && band_ok
}
