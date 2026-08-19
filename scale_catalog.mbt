///|
/// A machine-readable description of a score exposed by this module.
///
/// The catalog is intentionally descriptive: it does not replace the source
/// notes or a local clinical validation process.
pub struct ScaleDescriptor {
  id : String
  title : String
  minimum : Int
  maximum : Int
  description : String
} derive(Debug, Eq)

///|
/// Return the stable catalog of score identifiers supported by this release.
pub fn scale_catalog() -> Array[ScaleDescriptor] {
  [
    {
      id: "gcs",
      title: "Glasgow Coma Scale",
      minimum: 3,
      maximum: 15,
      description: "Eye, verbal and motor response total",
    },
    {
      id: "mrs",
      title: "modified Rankin Scale",
      minimum: 0,
      maximum: 6,
      description: "Ordinal functional outcome stage",
    },
    {
      id: "hunt-hess",
      title: "Hunt-Hess",
      minimum: 1,
      maximum: 5,
      description: "Subarachnoid hemorrhage clinical grade",
    },
    {
      id: "wfns",
      title: "WFNS",
      minimum: 1,
      maximum: 5,
      description: "World Federation neurological grade",
    },
    {
      id: "modified-fisher",
      title: "modified Fisher",
      minimum: 0,
      maximum: 4,
      description: "CT blood burden grade",
    },
    {
      id: "ich-score",
      title: "ICH Score",
      minimum: 0,
      maximum: 6,
      description: "Intracerebral hemorrhage aggregate points",
    },
    {
      id: "aspects",
      title: "ASPECTS",
      minimum: 0,
      maximum: 10,
      description: "Unaffected-region score",
    },
  ]
}

///|
/// Look up a score descriptor without throwing on an unknown identifier.
pub fn scale_descriptor(id : String) -> ScaleDescriptor? {
  for descriptor in scale_catalog() {
    if descriptor.id == id {
      return Some(descriptor)
    }
  }
  None
}
