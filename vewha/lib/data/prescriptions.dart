// lib/data/prescriptions.dart
// Static study prescription set — no network, no Firebase.

enum BodySystem {
  endocrine,      // Metformin — pancreas/liver
  respiratory,    // Salbutamol — bronchi/lungs
  integumentary,  // Betamethasone — skin
  cardiovascular, // Amlodipine — heart/vessels
  systemic,       // Prednisolone — adrenal/immune (non-obvious probe)
}

class StudyDrug {
  final String drugId;
  final String name;
  final String dose;
  final String route;
  final String frequency;
  final String purpose;
  final BodySystem bodySystem;
  final String plainLanguageKey;
  final bool isNonObvious;

  const StudyDrug({
    required this.drugId,
    required this.name,
    required this.dose,
    required this.route,
    required this.frequency,
    required this.purpose,
    required this.bodySystem,
    required this.plainLanguageKey,
    required this.isNonObvious,
  });
}

const List<StudyDrug> studyDrugs = [
  StudyDrug(
    drugId: 'metformin_01',
    name: 'Metformin 500mg',
    dose: '500mg',
    route: 'Oral (swallow)',
    frequency: 'Twice daily with meals',
    purpose: 'Type 2 diabetes mellitus — blood glucose control',
    bodySystem: BodySystem.endocrine,
    plainLanguageKey: 'metformin_01',
    isNonObvious: false,
  ),
  StudyDrug(
    drugId: 'salbutamol_01',
    name: 'Salbutamol Inhaler 100mcg',
    dose: '100mcg per puff, 1–2 puffs',
    route: 'Inhaled',
    frequency: 'As needed (maximum 4 times daily)',
    purpose: 'Asthma / bronchospasm — opens the airways',
    bodySystem: BodySystem.respiratory,
    plainLanguageKey: 'salbutamol_01',
    isNonObvious: false,
  ),
  StudyDrug(
    drugId: 'betamethasone_01',
    name: 'Betamethasone Cream 0.1%',
    dose: 'Thin layer',
    route: 'Topical (apply to skin)',
    frequency: 'Twice daily to affected area',
    purpose: 'Eczema / skin inflammation — reduces redness and itch',
    bodySystem: BodySystem.integumentary,
    plainLanguageKey: 'betamethasone_01',
    isNonObvious: false,
  ),
  StudyDrug(
    drugId: 'amlodipine_01',
    name: 'Amlodipine 5mg',
    dose: '5mg',
    route: 'Oral (swallow)',
    frequency: 'Once daily',
    purpose: 'High blood pressure / angina — relaxes blood vessels',
    bodySystem: BodySystem.cardiovascular,
    plainLanguageKey: 'amlodipine_01',
    isNonObvious: false,
  ),
  StudyDrug(
    drugId: 'prednisolone_01',
    name: 'Prednisolone 5mg (Tapering)',
    dose: '5mg (reducing dose — see schedule)',
    route: 'Oral (swallow)',
    frequency: 'As per tapering schedule — start 4 tablets daily',
    purpose: 'Inflammation / immune suppression — reduces immune response',
    bodySystem: BodySystem.systemic,
    plainLanguageKey: 'prednisolone_01',
    isNonObvious: true, // Non-obvious probe: often prescribed for respiratory/joint
                        // conditions but acts on adrenal/immune system
  ),
];
