import type { PluginListenerHandle } from '@capacitor/core';

export interface CapacitorMuseTrainerMidiPlugin {
  addListener(
    eventName: 'deviceChange' | 'commandReceive' | 'connectError',
    listenerFunc: (args: any) => void,
  ): Promise<PluginListenerHandle>;

  sendCommand({
    command,
    timestamp,
  }: {
    command: number[];
    timestamp: number;
  }): Promise<void>;
  listDevices(): Promise<{ devices: any[] }>;
}
