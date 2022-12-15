export interface CapacitorMuseTrainerMidiPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
