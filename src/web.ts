import { WebPlugin } from '@capacitor/core';

import type { CapacitorMuseTrainerMidiPlugin } from './definitions';

export class CapacitorMuseTrainerMidiWeb
  extends WebPlugin
  implements CapacitorMuseTrainerMidiPlugin
{
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
