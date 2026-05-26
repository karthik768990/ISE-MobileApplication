// lib/data/plain_language_map.dart
// Hand-written plain-language descriptions for each study drug.
// Two languages: English ('en') and Telugu ('te').
// DO NOT generate these with NLP — they are manually written for accuracy.

class PlainLangEntry {
  final String whatItIsFor;
  final String howToTake;
  final String audioText; // Full string read aloud by TTS

  const PlainLangEntry({
    required this.whatItIsFor,
    required this.howToTake,
    required this.audioText,
  });
}

const Map<String, Map<String, PlainLangEntry>> plainLanguageMap = {
  'metformin_01': {
    'en': PlainLangEntry(
      whatItIsFor: 'This medicine helps control the amount of sugar in your blood.',
      howToTake: 'Take one tablet twice a day. Always take it with your meals.',
      audioText: 'Metformin. This medicine helps control the amount of sugar in your blood. Take one tablet twice a day. Always take it with your meals.',
    ),
    'te': PlainLangEntry(
      whatItIsFor: 'ఈ మందు మీ రక్తంలో చక్కెర స్థాయిని నియంత్రించడంలో సహాయపడుతుంది.',
      howToTake: 'రోజుకు రెండు సార్లు భోజనంతో ఒక మాత్ర వేసుకోండి.',
      audioText: 'మెట్ఫార్మిన్. ఈ మందు మీ రక్తంలో చక్కెర స్థాయిని నియంత్రించడంలో సహాయపడుతుంది. రోజుకు రెండు సార్లు భోజనంతో ఒక మాత్ర వేసుకోండి.',
    ),
  },
  'salbutamol_01': {
    'en': PlainLangEntry(
      whatItIsFor: 'This inhaler opens up your airways and helps you breathe more easily when you feel short of breath.',
      howToTake: 'Use 1 or 2 puffs when you need it. Shake the inhaler first. Do not use it more than 4 times in one day.',
      audioText: 'Salbutamol inhaler. This inhaler opens up your airways and helps you breathe more easily. Use 1 or 2 puffs when you need it. Shake the inhaler first. Do not use it more than 4 times in one day.',
    ),
    'te': PlainLangEntry(
      whatItIsFor: 'ఈ ఇన్హేలర్ మీ శ్వాస నాళాలను తెరుస్తుంది మరియు శ్వాస తీసుకోవడం సులభం చేస్తుంది.',
      howToTake: 'అవసరమైనప్పుడు 1 లేదా 2 పఫ్లు వాడండి. ఒక రోజులో 4 సార్లకు మించి వాడకండి.',
      audioText: 'సాల్బుటమాల్ ఇన్హేలర్. ఈ ఇన్హేలర్ మీ శ్వాస నాళాలను తెరుస్తుంది. అవసరమైనప్పుడు 1 లేదా 2 పఫ్లు వాడండి. ఒక రోజులో 4 సార్లకు మించి వాడకండి.',
    ),
  },
  'betamethasone_01': {
    'en': PlainLangEntry(
      whatItIsFor: 'This cream reduces redness, itching, and swelling on your skin.',
      howToTake: 'Apply a thin layer to the affected area of skin twice a day. Wash your hands before and after applying.',
      audioText: 'Betamethasone cream. This cream reduces redness, itching, and swelling on your skin. Apply a thin layer to the affected area twice a day. Wash your hands before and after applying.',
    ),
    'te': PlainLangEntry(
      whatItIsFor: 'ఈ క్రీమ్ చర్మంపై ఎరుపు, దురద మరియు వాపును తగ్గిస్తుంది.',
      howToTake: 'ప్రభావిత చర్మంపై రోజుకు రెండు సార్లు సన్నగా పూయండి. వేయడానికి ముందు మరియు తర్వాత చేతులు కడుక్కోండి.',
      audioText: 'బెటామెతసోన్ క్రీమ్. ఈ క్రీమ్ చర్మంపై ఎరుపు, దురద మరియు వాపును తగ్గిస్తుంది. ప్రభావిత చర్మంపై రోజుకు రెండు సార్లు సన్నగా పూయండి.',
    ),
  },
  'amlodipine_01': {
    'en': PlainLangEntry(
      whatItIsFor: 'This medicine helps lower your blood pressure and keeps your heart working smoothly.',
      howToTake: 'Take one tablet once a day. You can take it at any time of day but try to take it at the same time each day.',
      audioText: 'Amlodipine. This medicine helps lower your blood pressure. Take one tablet once a day, at the same time each day.',
    ),
    'te': PlainLangEntry(
      whatItIsFor: 'ఈ మందు మీ రక్తపోటును తగ్గించడంలో సహాయపడుతుంది మరియు మీ గుండె సరిగ్గా పనిచేయడానికి సహాయం చేస్తుంది.',
      howToTake: 'రోజుకు ఒకసారి ఒక మాత్ర వేసుకోండి. ప్రతి రోజూ అదే సమయంలో వేసుకోవడానికి ప్రయత్నించండి.',
      audioText: 'అమ్లోడిపిన్. ఈ మందు మీ రక్తపోటును తగ్గిస్తుంది. రోజుకు ఒకసారి, అదే సమయంలో ఒక మాత్ర వేసుకోండి.',
    ),
  },
  'prednisolone_01': {
    'en': PlainLangEntry(
      whatItIsFor: 'This medicine calms down your immune system and reduces swelling and inflammation inside your body.',
      howToTake: 'Take the tablets as shown in your tapering schedule. Start with 4 tablets a day and reduce as instructed. Always take with food. Do not stop suddenly.',
      audioText: 'Prednisolone. This medicine calms down your immune system and reduces inflammation. Follow your tapering schedule carefully. Start with 4 tablets a day and reduce as instructed. Always take with food. Do not stop suddenly.',
    ),
    'te': PlainLangEntry(
      whatItIsFor: 'ఈ మందు మీ రోగనిరోధక వ్యవస్థను శాంతింపజేస్తుంది మరియు శరీరంలో వాపు మరియు మంటను తగ్గిస్తుంది.',
      howToTake: 'మీ టేపరింగ్ షెడ్యూల్ ప్రకారం మాత్రలు వేసుకోండి. రోజుకు 4 మాత్రలతో మొదలుపెట్టండి. ఆహారంతో వేసుకోండి. ఆకస్మికంగా ఆపవద్దు.',
      audioText: 'ప్రెడ్నిసోలోన్. ఈ మందు మీ రోగనిరోధక వ్యవస్థను శాంతింపజేస్తుంది. మీ షెడ్యూల్ ప్రకారం జాగ్రత్తగా వేసుకోండి. రోజుకు 4 మాత్రలతో మొదలుపెట్టండి. ఆహారంతో తీసుకోండి.',
    ),
  },
};
