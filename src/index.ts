import { registerPlugin } from '@capacitor/core';

import type { CapacitorMuseTrainerMidiPlugin } from './definitions';

const CapacitorMuseTrainerMidi = registerPlugin<CapacitorMuseTrainerMidiPlugin>(
  'CapacitorMuseTrainerMidi',
);

export * from './definitions';
export { CapacitorMuseTrainerMidi };
