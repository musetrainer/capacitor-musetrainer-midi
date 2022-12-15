export interface CapacitorMuseTrainerMidiPlugin {
  listDevices(): Promise<{ devices: any[] }>;
}
