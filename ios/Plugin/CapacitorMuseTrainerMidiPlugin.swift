import Foundation
import Capacitor
import MIKMIDI


@objc(CapacitorMuseTrainerMidiPlugin)
public class CapacitorMuseTrainerMidiPlugin: CAPPlugin {
    var midiDevicesObserver: NSKeyValueObservation?
    let deviceManager = MIKMIDIDeviceManager.shared
    
    public override func load() {
        midiDevicesObserver = deviceManager.observe(\.availableDevices) { (dm, _) in
            let d = Dictionary.init(uniqueKeysWithValues: dm.availableDevices.enumerated().map({ (String($0), $1.manufacturer ?? "Unknown") }))
            self.notifyListeners("deviceChanged", data: d)
            
            for source in self.deviceManager.connectedInputSources {
                do {
                    try self.deviceManager.connectInput(source) { (src, cmds) in
                        let cmd = Dictionary.init(uniqueKeysWithValues: cmds.map({
                            (String(describing: $0.commandType), $0)
                        }))
                        self.notifyListeners("midiData", data: cmd)
                    }
                } catch {
                    self.notifyListeners("connectError", data: [source.displayName ?? "Unknown":error])
                }
                
            }
        };
    }
    
    
    @objc func listDevices(_ call: CAPPluginCall) {
        call.resolve([
            "devices": MIKMIDIDeviceManager.shared.availableDevices
        ])
    }
}
