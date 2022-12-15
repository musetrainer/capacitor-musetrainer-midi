import { registerPlugin } from '@capacitor/core';

import type { CapacitorMuseTrainerMidiPlugin } from './definitions';

const CapacitorMuseTrainerMidi = registerPlugin<CapacitorMuseTrainerMidiPlugin>(
  'CapacitorMuseTrainerMidi',
  {
    web: () => import('./web').then(m => new m.CapacitorMuseTrainerMidiWeb()),
  },
);

export * from './definitions';
export { CapacitorMuseTrainerMidi };
