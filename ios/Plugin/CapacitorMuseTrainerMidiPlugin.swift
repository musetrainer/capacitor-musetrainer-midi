import Foundation
import Capacitor
import MIKMIDI

@objc(CapacitorMuseTrainerMidiPlugin)
public class CapacitorMuseTrainerMidiPlugin: CAPPlugin {
    var midiDevicesObserver: NSKeyValueObservation?
    let deviceManager = MIKMIDIDeviceManager.shared

    override public func load() {
        midiDevicesObserver = deviceManager.observe(\.availableDevices) { (dm, _) in
            // Devices change
            let d = Dictionary.init(uniqueKeysWithValues: dm.availableDevices
                                        .enumerated()
                                        .filter({ !$1.isVirtual && $1.entities.count > 0 && !($1.manufacturer ?? "").isEmpty })
                                        .map({ (String($0), $1.manufacturer ?? "Unknown") }))
            self.notifyListeners("deviceChange", data: d)

            // Listen to MIDI events from all sources
            for device in self.deviceManager.availableDevices {
                for entity in device.entities {
                    for source in entity.sources {
                        do {
                            try self.deviceManager.connectInput(source, eventHandler: { (_, cmds) in
                                let cmdData = Dictionary.init(uniqueKeysWithValues: cmds
                                                                .enumerated()
                                                                .map({ (idx, cmd) in
                                                                    var cmdStr: String
                                                                    switch cmd.commandType {
                                                                    case .noteOff:
                                                                        cmdStr = "noteOff"
                                                                    case .noteOn:
                                                                        cmdStr = "noteOn"
                                                                    case .polyphonicKeyPressure:
                                                                        cmdStr = "polyphonicKeyPressure"
                                                                    case .controlChange:
                                                                        cmdStr = "controlChage"
                                                                    case .programChange:
                                                                        cmdStr = "programChange"
                                                                    case .channelPressure:
                                                                        cmdStr = "channelPressure"
                                                                    case .pitchWheelChange:
                                                                        cmdStr = "pitchWheelChange"
                                                                    case .systemMessage:
                                                                        cmdStr = "systemMessage"
                                                                    case .systemExclusive:
                                                                        cmdStr = "systemExclusive"
                                                                    case .systemTimecodeQuarterFrame:
                                                                        cmdStr = "systemTimecodeQuarterFrame"
                                                                    case .systemSongPositionPointer:
                                                                        cmdStr = "systemSongPositionPointer"
                                                                    case .systemSongSelect:
                                                                        cmdStr = "systemSongSelect"
                                                                    case .systemTuneRequest:
                                                                        cmdStr = "systemTuneRequest"
                                                                    case .systemTimingClock:
                                                                        cmdStr = "systemTimingClock"
                                                                    case .systemStartSequence:
                                                                        cmdStr = "systemStartSequence"
                                                                    case .systemContinueSequence:
                                                                        cmdStr = "systemContinueSequence"
                                                                    case .systemStopSequence:
                                                                        cmdStr = "systemStopSequence"
                                                                    case .systemKeepAlive:
                                                                        cmdStr = "systemKeepAlive"
                                                                    @unknown default:
                                                                        cmdStr = "unknown"
                                                                    }

                                                                    let cmdDict: [String: Any] = [
                                                                        "command": cmdStr,
                                                                        "type": cmd.commandType,
                                                                        "byte1": cmd.dataByte1,
                                                                        "byte2": cmd.dataByte2
                                                                    ]

                                                                    var cmdJson = Data.init()
                                                                    do {
                                                                        cmdJson = try JSONSerialization.data(withJSONObject: cmdDict, options: [])
                                                                    } catch {}
                                                                    let cmdJsonStr = String(data: cmdJson, encoding: String.Encoding.ascii)!

                                                                    return (String(idx), cmdJsonStr)
                                                                }))

                                self.notifyListeners("commandSend", data: cmdData)
                            })
                        } catch {
                            self.notifyListeners("connectError", data: [source.displayName ?? "Unknown": error])
                        }
                    }
                }
            }
        }
    }

    @objc func listDevices(_ call: CAPPluginCall) {
        call.resolve([
            "devices": MIKMIDIDeviceManager.shared.availableDevices
        ])
    }
}
