import Foundation
import Capacitor
import MIKMIDI

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(CapacitorMuseTrainerMidiPlugin)
public class CapacitorMuseTrainerMidiPlugin: CAPPlugin {
    var midiDevicesObserver: NSKeyValueObservation?
    let deviceManager = MIKMIDIDeviceManager.shared

    public override func load() {
        midiDevicesObserver = deviceManager.observe(\.availableDevices) { (dm, _) in
            let d = Dictionary.init(uniqueKeysWithValues: dm.availableDevices.map({ ($0.manufacturer ?? "", $0.model ?? "") }))
            self.notifyListeners("deviceChange", data: d)
        };        <#code#>
    }


    @objc func listDevices(_ call: CAPPluginCall) {
        call.resolve([
            "value": MIKMIDIDeviceManager.shared.availableDevices
        ])
    }
}
