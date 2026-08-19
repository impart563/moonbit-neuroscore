///|
/// Parse one RFC-4180-style row. Quoted fields may contain commas and escaped
/// quotes. Newlines are handled by the caller so row diagnostics remain clear.
pub fn parse_csv_row(row : String) -> Array[String] raise ScoreError {
  if row == "" {
    raise EmptyInput
  }
  let fields : Array[String] = []
  let mut builder = StringBuilder::new()
  let mut quoted = false
  let mut escaped_quote = false
  for char in row {
    if escaped_quote {
      if char == '"' {
        builder.write_char('"')
        escaped_quote = false
      } else {
        raise InvalidRow(row=0, reason="unexpected character after quote")
      }
    } else if char == '"' {
      quoted = !quoted
    } else if char == ',' && !quoted {
      fields.push(builder.to_string())
      builder = StringBuilder::new()
    } else {
      builder.write_char(char)
    }
  }
  if quoted || escaped_quote {
    raise InvalidRow(row=0, reason="unterminated quoted field")
  }
  fields.push(builder.to_string())
  fields
}

///|
pub struct BatchSummary {
  total : Int
  successes : Int
  failures : Int
  records : Array[EvaluationRecord]
} derive(Debug)

///|
pub fn evaluate_csv_rows(
  scale~ : String,
  rows~ : Array[String],
) -> BatchSummary {
  let records : Array[EvaluationRecord] = []
  let mut successes = 0
  let mut failures = 0
  for index, row in rows {
    let record = try {
      let columns = parse_csv_row(row)
      let fields = columns.map(fn(value) {
        score_input(
          label="value",
          value=@string.parse_int(value) catch { _ => 0 },
        )
      })
      evaluate_scale(case_id="\{scale}-\{index}", scale~, fields~)
    } catch {
      error => evaluation_failure(case_id="\{scale}-\{index}", scale~, error~)
    }
    records.push(record)
    if record.is_success() {
      successes += 1
    } else {
      failures += 1
    }
  }
  { total: rows.length(), successes, failures, records }
}

///|
pub fn score_result_fhir_observation(
  result : ScoreResult,
  identifier : String,
) -> String {
  "{\"resourceType\":\"Observation\",\"id\":\"\{identifier}\",\"status\":\"final\",\"code\":{\"text\":\"\{result.name}\"},\"valueInteger\":\{result.total},\"interpretation\":{\"text\":\"\{band_name(result.band)}\"}}"
}
