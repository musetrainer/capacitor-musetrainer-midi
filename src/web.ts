/* eslint-disable @typescript-eslint/ban-ts-comment */
import type { ListenerCallback, PluginListenerHandle } from '@capacitor/core';
import { WebPlugin } from '@capacitor/core';

import type { CapacitorMuseTrainerMidiPlugin } from './definitions';

import MIDIAccess = WebMidi.MIDIAccess;
import MIDIMessageEvent = WebMidi.MIDIMessageEvent;
import MIDIInput = WebMidi.MIDIInput;
import MIDIOutput = WebMidi.MIDIOutput;

export class CapacitorMuseTrainerMidiWeb
  extends WebPlugin
  implements CapacitorMuseTrainerMidiPlugin
{
  midiInputs: MIDIInput[] = [];
  midiOutputs: MIDIOutput[] = [];
  access: MIDIAccess | null = null;

  async addListener(
    eventName: string,
    listenerFunc: ListenerCallback,
    // @ts-ignore https://github.com/typescript-eslint/typescript-eslint/issues/2034
  ): Promise<PluginListenerHandle> & PluginListenerHandle {
    if (eventName === 'deviceChange') {
      if (!this.access) {
        await this.listDevices();
      }

      if (this.access) {
        this.access.onstatechange = () => listenerFunc(this.listDevices());
      }

      return {
        remove: async () => {
          if (this.access) {
            this.access.onstatechange = () => {
              // Do nothing
            };
          }
        },
      };
    }

    if (eventName === 'commandReceive') {
      this.midiInputs.forEach(mi => {
        mi.onmidimessage = (event: MIDIMessageEvent) => {
          const NOTE_ON = 9;
          const NOTE_OFF = 8;
          const cmd = event.data[0] >> 4;
          let pitch = 0;
          if (event.data.length > 1) pitch = event.data[1];
          let velocity = 0;
          if (event.data.length > 2) velocity = event.data[2];
          if (cmd === NOTE_OFF || (cmd === NOTE_ON && velocity === 0)) {
            listenerFunc({
              type: 'noteOff',
              dataByte1: pitch,
              dataByte2: velocity,
            });
          } else if (cmd === NOTE_ON) {
            listenerFunc({
              type: 'noteOn',
              dataByte1: pitch,
              dataByte2: velocity,
            });
          }
        };
      });

      return {
        remove: async () => {
          this.midiInputs.forEach(
            mi =>
              (mi.onmidimessage = () => {
                // Do nothing
              }),
          );
        },
      };
    }

    return {
      remove: async () => {
        // Do nothing
      },
    };
  }

  async sendCommand({
    command,
    timestamp,
  }: {
    command: number[];
    timestamp: number;
  }): Promise<void> {
    this.midiOutputs.forEach(out => {
      out.send(command, timestamp);
    });
  }

  async listDevices(): Promise<{ devices: any[] }> {
    this.access = await navigator.requestMIDIAccess?.({ sysex: true });
    const inputs = [];
    const outputs = [];

    const iterInputs = this.access.inputs.values();
    for (let o = iterInputs.next(); !o.done; o = iterInputs.next()) {
      if (!o.value.name?.includes('Midi Through')) inputs.push(o.value);
    }

    const iterOutputs = this.access.outputs.values();
    for (let o = iterOutputs.next(); !o.done; o = iterOutputs.next()) {
      if (!o.value.name?.includes('Midi Through')) outputs.push(o.value);
    }

    this.midiInputs = inputs;
    this.midiOutputs = outputs;

    return { devices: inputs.map(d => d.manufacturer || '') };
  }
}
