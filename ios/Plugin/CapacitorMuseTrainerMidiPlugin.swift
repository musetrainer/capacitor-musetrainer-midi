import Foundation
import Capacitor
import MIKMIDI

@objc(CapacitorMuseTrainerMidiPlugin)
public class CapacitorMuseTrainerMidiPlugin: CAPPlugin {
    var midiDevicesObserver: NSKeyValueObservation?
    let deviceManager = MIKMIDIDeviceManager.shared
    
    func validDevice(dv: MIKMIDIDevice) -> Bool {
        !dv.isVirtual && dv.entities.count > 0 && !(dv.manufacturer ?? "").isEmpty
    }
    
    func alreadyConnected(_ sources: [MIKMIDISourceEndpoint], _ source: MIKMIDISourceEndpoint) -> Bool {
        for src in sources {
            if src == source {
                return true
            }
        }
        return false
    }
    
    func listenForDevices(_ dm: MIKMIDIDeviceManager) {
        let d = Dictionary.init(uniqueKeysWithValues: dm.availableDevices
            .filter(self.validDevice)
            .enumerated()
            .map({ (String($0), $1.manufacturer ?? "") }))
        self.notifyListeners("deviceChange", data: d)
    }
    
    func listenForCommands(_ dm: MIKMIDIDeviceManager) {
        for device in dm.availableDevices.filter(self.validDevice) {
            for entity in device.entities {
                for source in entity.sources {
                    if self.alreadyConnected(dm.connectedInputSources, source) {
                        continue
                    }
                    
                    do {
                        try self.deviceManager.connectInput(source, eventHandler: { (_, cmds) in
                            for cmd in cmds {
                                var cmdType: String
                                switch cmd.commandType {
                                case .noteOff:
                                    cmdType = "noteOff"
                                case .noteOn:
                                    cmdType = "noteOn"
                                case .polyphonicKeyPressure:
                                    cmdType = "polyphonicKeyPressure"
                                case .controlChange:
                                    cmdType = "controlChage"
                                case .programChange:
                                    cmdType = "programChange"
                                case .channelPressure:
                                    cmdType = "channelPressure"
                                case .pitchWheelChange:
                                    cmdType = "pitchWheelChange"
                                case .systemMessage:
                                    cmdType = "systemMessage"
                                case .systemExclusive:
                                    cmdType = "systemExclusive"
                                case .systemTimecodeQuarterFrame:
                                    cmdType = "systemTimecodeQuarterFrame"
                                case .systemSongPositionPointer:
                                    cmdType = "systemSongPositionPointer"
                                case .systemSongSelect:
                                    cmdType = "systemSongSelect"
                                case .systemTuneRequest:
                                    cmdType = "systemTuneRequest"
                                case .systemTimingClock:
                                    cmdType = "systemTimingClock"
                                case .systemStartSequence:
                                    cmdType = "systemStartSequence"
                                case .systemContinueSequence:
                                    cmdType = "systemContinueSequence"
                                case .systemStopSequence:
                                    cmdType = "systemStopSequence"
                                case .systemKeepAlive:
                                    cmdType = "systemKeepAlive"
                                @unknown default:
                                    cmdType = "unknown"
                                }
                                
                                self.notifyListeners("commandReceive", data: [
                                    "type": cmdType,
                                    "dataByte1": cmd.dataByte1,
                                    "dataByte2": cmd.dataByte2
                                ])
                            }
                        })
                    } catch {
                        self.notifyListeners("connectError", data: [source.displayName ?? "Unknown": String(describing: error)])
                    }
                }
            }
        }
    }
    
    override public func load() {
        midiDevicesObserver = deviceManager.observe(\.availableDevices) { (dm, _) in
            // Listen for devices change
            self.listenForDevices(dm)
            
            // Listen for MIDI events from all sources
            self.listenForCommands(dm)
        }
    }
    
    @objc func listDevices(_ call: CAPPluginCall) {
        // Attach input sources
        if deviceManager.connectedInputSources.count == 0 {
            self.listenForDevices(deviceManager)
        }
        
        call.resolve(
            Dictionary.init(uniqueKeysWithValues: deviceManager.availableDevices
                .filter(self.validDevice)
                .enumerated()
                .map({ (String($0), $1.manufacturer ?? "") })
            )
        )
    }
    
    @objc func sendCommand(_ call: CAPPluginCall) {
        let cmdArr = call.getArray("command") ?? []
        if cmdArr.isEmpty {
            call.reject("Invalid command")
            return
        }
        
        let cmd = cmdArr.map { UInt8( $0 as? Int ?? 0)}
        let ts = UInt64(truncatingIfNeeded: call.getInt("timestamp") ?? 0)
        let command = MIKMIDICommand.from(command: cmd, timestamp: ts)
        
        var err: Error?
        for device in deviceManager.availableDevices {
            for entity in device.entities {
                for dest in entity.destinations {
                    do {
                        try deviceManager.send([command], to: dest)
                    } catch {
                        err = error
                    }
                }
            }
        }
        
        if let e = err {
            call.reject(e.localizedDescription)
        } else {
            call.resolve()
        }
    }
}
