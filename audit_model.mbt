///|
pub(all) enum AuditKind {
  EvaluationStarted
  EvaluationCompleted
  EvaluationRejected
  BatchStarted
  BatchCompleted
} derive(Debug, Eq)

///|
pub struct AuditEvent {
  sequence : Int
  kind : AuditKind
  scale : String
  case_id : String
  detail : String
} derive(Debug, Eq)

///|
pub fn audit_event(
  sequence~ : Int,
  kind~ : AuditKind,
  scale~ : String,
  case_id~ : String,
  detail~ : String,
) -> AuditEvent {
  { sequence, kind, scale, case_id, detail }
}

///|
pub fn AuditEvent::kind_name(self : AuditEvent) -> String {
  match self.kind {
    EvaluationStarted => "evaluation_started"
    EvaluationCompleted => "evaluation_completed"
    EvaluationRejected => "evaluation_rejected"
    BatchStarted => "batch_started"
    BatchCompleted => "batch_completed"
  }
}

///|
pub fn AuditEvent::to_json(self : AuditEvent) -> String {
  "{\"sequence\":\{self.sequence},\"kind\":\"\{self.kind_name()}\",\"scale\":\"\{self.scale}\",\"case_id\":\"\{self.case_id}\",\"detail\":\"\{self.detail}\"}"
}
