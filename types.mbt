///|
pub(all) enum RiskBand {
  Low
  Moderate
  High
  Severe
  NotApplicable
} derive(Debug, Eq)

///|
pub struct ScoreInput {
  label : String
  value : Int
} derive(Debug)

///|
pub fn score_input(label~ : String, value~ : Int) -> ScoreInput {
  { label, value }
}

///|
pub struct EvidenceNote {
  source : String
  note : String
} derive(Debug)

///|
pub struct ScoreResult {
  name : String
  total : Int
  band : RiskBand
  missing : Array[String]
  explanation : String
  evidence : Array[EvidenceNote]
} derive(Debug)

///|
fn complete(
  name : String,
  total : Int,
  band : RiskBand,
  explanation : String,
) -> ScoreResult {
  {
    name,
    total,
    band,
    missing: [],
    explanation,
    evidence: [
      {
        source: "SOURCES.md",
        note: "Public ordinal scale; verify edition before clinical use",
      },
    ],
  }
}

///|
fn incomplete(
  name : String,
  missing : Array[String],
  explanation : String,
) -> ScoreResult {
  { name, total: 0, band: NotApplicable, missing, explanation, evidence: [] }
}
