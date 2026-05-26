// lib/data/prescriptions.dart
// Static study prescription set — no network, no Firebase.

enum BodySystem {
  endocrine,      // Metformin — pancreas/liver
  respiratory,    // Salbutamol — bronchi/lungs
  integumentary,  // Betamethasone — skin
  cardiovascular, // Amlodipine — heart/vessels
  systemic,       // Prednisolone — adrenal/immune (non-obvious probe)
}

class BilingualQuestion {
  final String id;
  final String questionEn;
  final String questionTe;
  final String expectedEn; // lowercase keywords separated by comma
  final String expectedTe; // Telugu keywords separated by comma

  const BilingualQuestion({
    required this.id,
    required this.questionEn,
    required this.questionTe,
    required this.expectedEn,
    required this.expectedTe,
  });
}

class StudyDrug {
  final String drugId;
  final String name;
  final String nameTe;
  final String dose;
  final String doseTe;
  final String route;
  final String routeTe;
  final String frequency;
  final String frequencyTe;
  final String purpose;
  final String purposeTe;
  final BodySystem bodySystem;
  final String plainLanguageKey;
  final bool isNonObvious;
  final List<BilingualQuestion> questions;

  const StudyDrug({
    required this.drugId,
    required this.name,
    required this.nameTe,
    required this.dose,
    required this.doseTe,
    required this.route,
    required this.routeTe,
    required this.frequency,
    required this.frequencyTe,
    required this.purpose,
    required this.purposeTe,
    required this.bodySystem,
    required this.plainLanguageKey,
    required this.isNonObvious,
    required this.questions,
  });
}

const List<StudyDrug> studyDrugs = [
  StudyDrug(
    drugId: 'metformin_01',
    name: 'Metformin 500mg',
    nameTe: 'మెట్ఫార్మిన్ 500mg',
    dose: '500mg',
    doseTe: '500mg',
    route: 'Oral (swallow)',
    routeTe: 'నోటి ద్వారా (మింగాలి)',
    frequency: 'Twice daily with meals',
    frequencyTe: 'భోజనంతో పాటు రోజుకు రెండు సార్లు',
    purpose: 'Type 2 diabetes mellitus — blood glucose control',
    purposeTe: 'టైప్ 2 మధుమేహం — రక్తంలో గ్లూకోజ్ నియంత్రణ',
    bodySystem: BodySystem.endocrine,
    plainLanguageKey: 'metformin_01',
    isNonObvious: false,
    questions: [
      BilingualQuestion(
        id: 'q_purpose',
        questionEn: 'What problem does this medicine help with?',
        questionTe: 'ఈ మందు ఏ సమస్యకు సహాయపడుతుంది?',
        expectedEn: 'sugar,diabetes,glucose',
        expectedTe: 'చక్కెర,మధుమేహం,గ్లూకోజ్,షుగర్',
      ),
      BilingualQuestion(
        id: 'q_freq',
        questionEn: 'When or how often should you take this medicine?',
        questionTe: 'ఈ మందును ఎప్పుడు లేదా ఎంత తరచుగా తీసుకోవాలి?',
        expectedEn: 'twice,meals,day,daily',
        expectedTe: 'రెండు,భోజనం,రోజుకు',
      ),
      BilingualQuestion(
        id: 'q_use',
        questionEn: 'How should you use or take this medicine?',
        questionTe: 'ఈ మందును ఎలా ఉపయోగించాలి లేదా తీసుకోవాలి?',
        expectedEn: 'swallow,oral,water',
        expectedTe: 'మింగాలి,నోటి,మింగడం',
      ),
      BilingualQuestion(
        id: 'q_body',
        questionEn: 'Which part of the body does this medicine help?',
        questionTe: 'ఈ మందు శరీరంలో ఏ భాగానికి సహాయపడుతుంది?',
        expectedEn: 'pancreas,liver,endocrine',
        expectedTe: 'జీర్ణ,కాలేయం,మేదోజనిత,ఎండోక్రైన్',
      ),
      BilingualQuestion(
        id: 'q_safety',
        questionEn: 'Should this medicine be taken with food?',
        questionTe: 'ఈ మందును ఆహారంతో తీసుకోవాలా?',
        expectedEn: 'yes,with meals,food',
        expectedTe: 'అవును,భోజనంతో,ఆహారం',
      ),
      BilingualQuestion(
        id: 'q_verify',
        questionEn: 'Did you understand the instructions for this medicine?',
        questionTe: 'మీకు ఈ మందు గురించిన సూచనలు సరిగ్గా అర్థమయ్యాయా?',
        expectedEn: 'yes',
        expectedTe: 'అవును',
      ),
    ],
  ),
  StudyDrug(
    drugId: 'salbutamol_01',
    name: 'Salbutamol Inhaler 100mcg',
    nameTe: 'సాల్బుటమాల్ ఇన్హేలర్ 100mcg',
    dose: '100mcg per puff, 1–2 puffs',
    doseTe: 'ప్రతి పఫ్‌కు 100mcg, 1–2 పఫ్‌లు',
    route: 'Inhaled',
    routeTe: 'పీల్చడం ద్వారా',
    frequency: 'As needed (maximum 4 times daily)',
    frequencyTe: 'అవసరమైనప్పుడు (రోజుకు గరిష్టంగా 4 సార్లు)',
    purpose: 'Asthma / bronchospasm — opens the airways',
    purposeTe: 'ఆస్తమా / శ్వాసనాళాల సంకోచం — శ్వాస నాళాలను తెరుస్తుంది',
    bodySystem: BodySystem.respiratory,
    plainLanguageKey: 'salbutamol_01',
    isNonObvious: false,
    questions: [
      BilingualQuestion(
        id: 'q_purpose',
        questionEn: 'What problem does this medicine help with?',
        questionTe: 'ఈ మందు ఏ సమస్యకు సహాయపడుతుంది?',
        expectedEn: 'asthma,breathe,breathing,shortness,airway',
        expectedTe: 'ఆస్తమా,శ్వాస,ఆయాసం,నాళాలు',
      ),
      BilingualQuestion(
        id: 'q_freq',
        questionEn: 'When or how often should you take this medicine?',
        questionTe: 'ఈ మందును ఎప్పుడు లేదా ఎంత తరచుగా తీసుకోవాలి?',
        expectedEn: 'needed,need,as needed,maximum 4',
        expectedTe: 'అవసరమైనప్పుడు,గరిష్టంగా,4 సార్లు',
      ),
      BilingualQuestion(
        id: 'q_use',
        questionEn: 'How should you use or take this medicine?',
        questionTe: 'ఈ మందును ఎలా ఉపయోగించాలి లేదా తీసుకోవాలి?',
        expectedEn: 'inhale,inhaled,puffs,mouth',
        expectedTe: 'పీల్చడం,ఇన్హేలర్,పఫ్',
      ),
      BilingualQuestion(
        id: 'q_body',
        questionEn: 'Which part of the body does this medicine help?',
        questionTe: 'ఈ మందు శరీరంలో ఏ భాగానికి సహాయపడుతుంది?',
        expectedEn: 'lungs,bronchi,respiratory,chest',
        expectedTe: 'ఊపిరితిత్తులు,శ్వాసనాళాలు,రెస్పిరేటరీ',
      ),
      BilingualQuestion(
        id: 'q_safety',
        questionEn: 'What is the maximum number of times you can use this inhaler in one day?',
        questionTe: 'ఈ ఇన్హేలర్‌ను ఒక రోజులో గరిష్టంగా ఎన్ని సార్లు వాడవచ్చు?',
        expectedEn: '4,four',
        expectedTe: '4 సార్లు,నాలుగు,4',
      ),
      BilingualQuestion(
        id: 'q_verify',
        questionEn: 'Did you understand the instructions for this medicine?',
        questionTe: 'మీకు ఈ మందు గురించిన సూచనలు సరిగ్గా అర్థమయ్యాయా?',
        expectedEn: 'yes',
        expectedTe: 'అవును',
      ),
    ],
  ),
  StudyDrug(
    drugId: 'betamethasone_01',
    name: 'Betamethasone Cream 0.1%',
    nameTe: 'బెటామెతసోన్ క్రీమ్ 0.1%',
    dose: 'Thin layer',
    doseTe: 'సన్నని పొర',
    route: 'Topical (apply to skin)',
    routeTe: 'బాహ్య పూత (చర్మంపై పూయాలి)',
    frequency: 'Twice daily to affected area',
    frequencyTe: 'ప్రభావిత ప్రాంతంలో రోజుకు రెండు సార్లు',
    purpose: 'Eczema / skin inflammation — reduces redness and itch',
    purposeTe: 'ఎగ్జిమా / చర్మపు మంట — ఎరుపు మరియు దురదను తగ్గిస్తుంది',
    bodySystem: BodySystem.integumentary,
    plainLanguageKey: 'betamethasone_01',
    isNonObvious: false,
    questions: [
      BilingualQuestion(
        id: 'q_purpose',
        questionEn: 'What problem does this medicine help with?',
        questionTe: 'ఈ మందు ఏ సమస్యకు సహాయపడుతుంది?',
        expectedEn: 'eczema,skin,itch,redness,inflammation',
        expectedTe: 'ఎగ్జిమా,దురద,ఎరుపు,చర్మం,మంట',
      ),
      BilingualQuestion(
        id: 'q_freq',
        questionEn: 'When or how often should you take this medicine?',
        questionTe: 'ఈ మందును ఎప్పుడు లేదా ఎంత తరచుగా తీసుకోవాలి?',
        expectedEn: 'twice,day,daily,2',
        expectedTe: 'రెండు,రోజుకు,2 సార్లు',
      ),
      BilingualQuestion(
        id: 'q_use',
        questionEn: 'How should you use or take this medicine?',
        questionTe: 'ఈ మందును ఎలా ఉపయోగించాలి లేదా తీసుకోవాలి?',
        expectedEn: 'apply,skin,cream,rub,topical',
        expectedTe: 'చర్మంపై,పూయాలి,రాయాలి',
      ),
      BilingualQuestion(
        id: 'q_body',
        questionEn: 'Which part of the body does this medicine help?',
        questionTe: 'ఈ మందు శరీరంలో ఏ భాగానికి సహాయపడుతుంది?',
        expectedEn: 'skin,integumentary',
        expectedTe: 'చర్మం,ఇంటెగ్యుమెంటరీ',
      ),
      BilingualQuestion(
        id: 'q_safety',
        questionEn: 'Should you wash your hands before and after applying this cream?',
        questionTe: 'ఈ క్రీమ్ రాయడానికి ముందు మరియు తరువాత చేతులు కడుక్కోవాలా?',
        expectedEn: 'yes,wash',
        expectedTe: 'అవును,కడుక్కోవాలి',
      ),
      BilingualQuestion(
        id: 'q_verify',
        questionEn: 'Did you understand the instructions for this medicine?',
        questionTe: 'మీకు ఈ మందు గురించిన సూచనలు సరిగ్గా అర్థమయ్యాయా?',
        expectedEn: 'yes',
        expectedTe: 'అవును',
      ),
    ],
  ),
  StudyDrug(
    drugId: 'amlodipine_01',
    name: 'Amlodipine 5mg',
    nameTe: 'అమ్లోడిపిన్ 5mg',
    dose: '5mg',
    doseTe: '5mg',
    route: 'Oral (swallow)',
    routeTe: 'నోటి ద్వారా (మింగాలి)',
    frequency: 'Once daily',
    frequencyTe: 'రోజుకు ఒకసారి',
    purpose: 'High blood pressure / angina — relaxes blood vessels',
    purposeTe: 'అధిక రక్తపోటు / గుండెనొప్పి — రక్తనాళాలను సడలిస్తుంది',
    bodySystem: BodySystem.cardiovascular,
    plainLanguageKey: 'amlodipine_01',
    isNonObvious: false,
    questions: [
      BilingualQuestion(
        id: 'q_purpose',
        questionEn: 'What problem does this medicine help with?',
        questionTe: 'ఈ మందు ఏ సమస్యకు సహాయపడుతుంది?',
        expectedEn: 'blood pressure,bp,hypertension,angina,heart',
        expectedTe: 'రక్తపోటు,బిపి,గుండెనొప్పి,గుండె',
      ),
      BilingualQuestion(
        id: 'q_freq',
        questionEn: 'When or how often should you take this medicine?',
        questionTe: 'ఈ మందును ఎప్పుడు లేదా ఎంత తరచుగా తీసుకోవాలి?',
        expectedEn: 'once,daily,day,1',
        expectedTe: 'ఒకసారి,రోజుకు,1 సారి',
      ),
      BilingualQuestion(
        id: 'q_use',
        questionEn: 'How should you use or take this medicine?',
        questionTe: 'ఈ మందును ఎలా ఉపయోగించాలి లేదా తీసుకోవాలి?',
        expectedEn: 'swallow,oral,water',
        expectedTe: 'మింగాలి,నోటి',
      ),
      BilingualQuestion(
        id: 'q_body',
        questionEn: 'Which part of the body does this medicine help?',
        questionTe: 'ఈ మందు శరీరంలో ఏ భాగానికి సహాయపడుతుంది?',
        expectedEn: 'heart,vessels,cardiovascular',
        expectedTe: 'గుండె,రక్తనాళాలు,కార్డియోవాస్కులర్',
      ),
      BilingualQuestion(
        id: 'q_safety',
        questionEn: 'Should you try to take this medicine at the same time each day?',
        questionTe: 'ఈ మందును ప్రతిరోజూ ఒకే సమయంలో వేసుకోవడానికి ప్రయత్నించాలా?',
        expectedEn: 'yes,same time',
        expectedTe: 'అవును,సమయం,సమయంలో',
      ),
      BilingualQuestion(
        id: 'q_verify',
        questionEn: 'Did you understand the instructions for this medicine?',
        questionTe: 'మీకు ఈ మందు గురించిన సూచనలు సరిగ్గా అర్థమయ్యాయా?',
        expectedEn: 'yes',
        expectedTe: 'అవును',
      ),
    ],
  ),
  StudyDrug(
    drugId: 'prednisolone_01',
    name: 'Prednisolone 5mg (Tapering)',
    nameTe: 'ప్రెడ్నిసోలోన్ 5mg (టేపరింగ్)',
    dose: '5mg (reducing dose — see schedule)',
    doseTe: '5mg (తగ్గించే మోతాదు — షెడ్యూల్ చూడండి)',
    route: 'Oral (swallow)',
    routeTe: 'నోటి ద్వారా (మింగాలి)',
    frequency: 'As per tapering schedule — start 4 tablets daily',
    frequencyTe: 'టేపరింగ్ షెడ్యూల్ ప్రకారం — రోజుకు 4 మాత్రలతో ప్రారంభించండి',
    purpose: 'Inflammation / immune suppression — reduces immune response',
    purposeTe: 'మంట / రోగనిరోధక శక్తి అణచివేత — రోగనిరోధక ప్రతిస్పందనను తగ్గిస్తుంది',
    bodySystem: BodySystem.systemic,
    plainLanguageKey: 'prednisolone_01',
    isNonObvious: true,
    questions: [
      BilingualQuestion(
        id: 'q_purpose',
        questionEn: 'What problem does this medicine help with?',
        questionTe: 'ఈ మందు ఏ సమస్యకు సహాయపడుతుంది?',
        expectedEn: 'inflammation,immune,swelling,allergy',
        expectedTe: 'మంట,వాపు,రోగనిరోధక,అలర్జీ',
      ),
      BilingualQuestion(
        id: 'q_freq',
        questionEn: 'When or how often should you take this medicine?',
        questionTe: 'ఈ మందును ఎప్పుడు లేదా ఎంత తరచుగా తీసుకోవాలి?',
        expectedEn: 'schedule,tapering,taper,reducing',
        expectedTe: 'షెడ్యూల్,తగ్గించే,టేపరింగ్',
      ),
      BilingualQuestion(
        id: 'q_use',
        questionEn: 'How should you use or take this medicine?',
        questionTe: 'ఈ మందును ఎలా ఉపయోగించాలి లేదా తీసుకోవాలి?',
        expectedEn: 'swallow,oral,with food,food',
        expectedTe: 'మింగాలి,నోటి,ఆహారంతో,ఆహారం',
      ),
      BilingualQuestion(
        id: 'q_body',
        questionEn: 'Which part of the body does this medicine help?',
        questionTe: 'ఈ మందు శరీరంలో ఏ భాగానికి సహాయపడుతుంది?',
        expectedEn: 'adrenal,immune,systemic,whole body',
        expectedTe: 'అడ్రినల్,రోగనిరోధక,సిస్టమిక్',
      ),
      BilingualQuestion(
        id: 'q_safety',
        questionEn: 'Can you stop taking this medicine suddenly without tapering?',
        questionTe: 'ఈ మందును ఆకస్మికంగా ఆపవచ్చా?',
        expectedEn: 'no,cannot,must not',
        expectedTe: 'లేదు,ఆపకూడదు,ఆపరాదు',
      ),
      BilingualQuestion(
        id: 'q_verify',
        questionEn: 'Did you understand the instructions for this medicine?',
        questionTe: 'మీకు ఈ మందు గురించిన సూచనలు సరిగ్గా అర్థమయ్యాయా?',
        expectedEn: 'yes',
        expectedTe: 'అవును',
      ),
    ],
  ),
];
