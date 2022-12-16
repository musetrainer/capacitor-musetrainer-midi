import type { PluginListenerHandle } from '@capacitor/core';

export interface CapacitorMuseTrainerMidiPlugin {
  addListener(
    eventName: 'deviceChange' | 'commandReceive' | 'connectError',
    listenerFunc: (args: any) => void,
  ): PluginListenerHandle;

  sendCommand(command: string, timestamp: number): Promise<void>;
  listDevices(): Promise<{ devices: any[] }>;
}
