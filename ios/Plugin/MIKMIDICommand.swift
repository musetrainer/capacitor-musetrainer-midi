import Foundation
import MIKMIDI

extension MIKMIDICommand {
    static func from(command: [UInt8], timestamp: UInt64) -> MIKMIDICommand {
        let packetLength = command.count
        let data = command
            .reduce(into: Data(capacity: packetLength)) { partialResult, chunk in
                partialResult.append(chunk)
            }
        var packet = MIDIPacket(timestamp: timestamp, length: packetLength, data: data)
        let packetPtr = UnsafeMutablePointer<MIDIPacket>.allocate(capacity: 1)
        packetPtr.initialize(from: &packet, count: 1)
        return MIKMIDICommand(midiPacket: packetPtr)
    }
}
