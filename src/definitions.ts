import type { PluginListenerHandle } from '@capacitor/core';

export interface CapacitorMuseTrainerMidiPlugin {
  addListener(
    eventName: 'deviceChange' | 'commandSend' | 'connectError',
    listenerFunc: (...args: any[]) => void,
  ): PluginListenerHandle;

  listDevices(): Promise<{ devices: any[] }>;
}
