///|
/// Structured failures shared by parsers, registries, and batch evaluators.
pub(all) suberror ScoreError {
  UnknownScale(String)
  InvalidField(label~ : String, value~ : String, reason~ : String)
  MissingField(label~ : String)
  InvalidRow(row~ : Int, reason~ : String)
  InvalidColumn(row~ : Int, column~ : String, reason~ : String)
  DuplicateField(label~ : String)
  EmptyInput
  UnsupportedVersion(scale~ : String, version~ : String)
} derive(Debug, Eq)

///|
pub fn score_error_code(error : ScoreError) -> String {
  match error {
    UnknownScale(_) => "unknown_scale"
    InvalidField(_) => "invalid_field"
    MissingField(_) => "missing_field"
    InvalidRow(_) => "invalid_row"
    InvalidColumn(_) => "invalid_column"
    DuplicateField(_) => "duplicate_field"
    EmptyInput => "empty_input"
    UnsupportedVersion(_) => "unsupported_version"
  }
}

///|
pub fn score_error_message(error : ScoreError) -> String {
  match error {
    UnknownScale(id) => "unknown scale: \{id}"
    InvalidField(label~, value~, reason~) =>
      "invalid field \{label}=\{value}: \{reason}"
    MissingField(label~) => "missing field: \{label}"
    InvalidRow(row~, reason~) => "invalid row \{row}: \{reason}"
    InvalidColumn(row~, column~, reason~) =>
      "invalid row \{row} column \{column}: \{reason}"
    DuplicateField(label~) => "duplicate field: \{label}"
    EmptyInput => "input is empty"
    UnsupportedVersion(scale~, version~) =>
      "unsupported version \{scale}@\{version}"
  }
}

///|
pub struct FieldDiagnostic {
  field : String
  value : String
  message : String
} derive(Debug, Eq)

///|
pub fn field_diagnostic(
  field~ : String,
  value~ : String,
  message~ : String,
) -> FieldDiagnostic {
  { field, value, message }
}
