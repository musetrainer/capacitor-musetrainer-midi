import Foundation
import MIKMIDI

extension MIKMIDICommand {
    static func from(command: String, timestamp: UInt64) -> MIKMIDICommand {
        let packetLength = (command.count + ((command.count % 2) * 2)) / 2
        let trimmedCommand = command.trimmingCharacters(in: .whitespaces)
        let data = stride(from: 0, to: trimmedCommand.count, by: 2)
            .map { index -> String in
                let start = trimmedCommand.index(trimmedCommand.startIndex, offsetBy: index)
                let end = trimmedCommand.index(start, offsetBy: 1, limitedBy: trimmedCommand.endIndex) ?? trimmedCommand.endIndex
                return String(trimmedCommand[start...end])
            }
            .compactMap { UInt8($0, radix: 16) }
            .reduce(into: Data(capacity: packetLength)) { partialResult, chunk in
                partialResult.append(chunk)
            }
        var packet = MIDIPacket(timestamp: timestamp, length: packetLength, data: data)
        let packetPtr = UnsafeMutablePointer<MIDIPacket>.allocate(capacity: 1)
        packetPtr.initialize(from: &packet, count: 1)
        return MIKMIDICommand(midiPacket: packetPtr)
    }
}
