// ignore_for_file: constant_identifier_names

import 'package:tangullo/modals/breathing_instructions.dart';
import 'package:tangullo/modals/breathing_modal.dart';

const BREATHINGDATA = [
  BreathingModal(
    image: 'assets/images/pursedlip.jpg',
    name: 'Pursed Lip Breathing',
    duration: '60', // Set to 60 seconds
    index: '0',
  ),
  BreathingModal(
    image: 'assets/images/equalbreathing.jpg',
    name: 'Equal Breathing',
    duration: '60', // Set to 60 seconds
    index: '1',
  ),
  BreathingModal(
    image: 'assets/images/resonance.png',
    name: 'Resonance Breathing',
    duration: '60', // Set to 60 seconds
    index: '2',
  ),
  BreathingModal(
    image: 'assets/images/sitalibreathing.jpg',
    name: 'Sitali Breathing',
    duration: '60', // Set to 60 seconds
    index: '3',
  ),
  BreathingModal(
    image: 'assets/images/bellybreathing.jpg',
    name: 'Belly Breathing',
    duration: '60', // Set to 60 seconds
    index: '4',
  ),
];

const BREATHINGINSTRU = [
  BreathingInstruc(
      breathingInstrc:
          'Relax your neck and shoulders.\n\nKeeping your mouth closed, inhale slowly through your nose for 2 counts.\n\n Pucker or purse your lips as though you were going to whistle. \n\nExhale slowly by blowing air through your pursed lips for a count of 4.'),
  BreathingInstruc(
    breathingInstrc:
        'Choose a comfortable seated position. \n\nBreathe in and out through your nose. \n\nCount during each inhale and exhale to make sure they are even in duration. Alternatively, choose a word or short phrase to repeat during each inhale and exhale. \n\nYou can add a slight pause or breath retention after each inhale and exhale if you feel comfortable. (Normal breathing involves a natural pause.) \n\nContinue practicing this breath for at least 5 minutes.',
  ),
  BreathingInstruc(
    breathingInstrc:
        'Breathing at this rate maximizes your heart rate variability (HRV), reduces stress.\n\n Inhale for a count of 5. \n\nExhale for a count of 5. \n\nContinue this breathing pattern for at least a 3 minutes.',
  ),
  BreathingInstruc(
    breathingInstrc:
        'This yoga breathing practice helps you lower your body temperature and relax your mind.\n\n Choose a comfortable seated position.\n\nStick out your tongue and curl your tongue to bring the outer edges together.\n\nIf your tongue doesn’t do this, you can purse your lips.\n\nInhale through your mouth.\n\nExhale out through your nose.\n\nContinue breathing like this for up to 5 minutes.',
  ),
  BreathingInstruc(
      breathingInstrc:
          'Sit or lie flat in a comfortable position. \n\nPut one hand on your belly just below your ribs and the other hand on your chest. \n\nTake a deep breath in through your nose, and let your belly push your hand out. Your chest should not move.\n\nBreathe out through pursed lips as if you were whistling. Feel the hand on your belly go in, and use it to push all the air out. \n\nDo this breathing 3 to 10 times. Take your time with each breath.\n\nNotice how you feel at the end of the exercise.'),
];
