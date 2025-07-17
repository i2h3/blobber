// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Foundation

@main
struct blobber: ParsableCommand {
    @Argument(help: "The output file path to write to")
    var outputPath: String
    
    @Argument(help: "Target file size (e.g., 1024, '200kb', '1mb', '4gb')")
    var targetSize: String
    
    mutating func run() throws {
        let sizeInBytes = try parseSize(targetSize)
        print("Writing to: \(outputPath)")
        print("Target size: \(sizeInBytes) bytes (\(targetSize))")
        
        try generateRandomFile(at: outputPath, size: sizeInBytes)
        print("Successfully created file with \(sizeInBytes) bytes of random data")
    }
    
    private func generateRandomFile(at path: String, size: Int64) throws {
        let url = URL(fileURLWithPath: path)
        let chunkSize = 1024 * 1024 // 1MB chunks to avoid high memory usage
        
        // Create the file
        guard FileManager.default.createFile(atPath: path, contents: nil, attributes: nil) else {
            throw ValidationError("Failed to create file at path: \(path)")
        }
        
        let fileHandle = try FileHandle(forWritingTo: url)

        defer {
            try? fileHandle.close()
        }
        
        var remainingBytes = size
        
        while remainingBytes > 0 {
            let currentChunkSize = min(Int(remainingBytes), chunkSize)
            let randomData = generateRandomData(size: currentChunkSize)
            
            try fileHandle.write(contentsOf: randomData)
            remainingBytes -= Int64(currentChunkSize)
            
            // Optional: Show progress for large files
            if size > 10 * 1024 * 1024 { // Show progress for files > 10MB
                let progress = Double(size - remainingBytes) / Double(size) * 100
                print(String(format: "Progress: %.1f%%", progress), terminator: "\r")
                fflush(stdout)
            }
        }
        
        if size > 10 * 1024 * 1024 {
            print() // New line after progress
        }
    }
    
    private func generateRandomData(size: Int) -> Data {
        var data = Data(count: size)

        data.withUnsafeMutableBytes { bytes in
            arc4random_buf(bytes.baseAddress!, size)
        }

        return data
    }
    
    private func parseSize(_ sizeString: String) throws -> Int64 {
        let trimmed = sizeString.trimmingCharacters(in: .whitespaces).lowercased()
        
        // Check if it's a plain number
        if let number = Int64(trimmed) {
            return number
        }
        
        // Parse size with units
        let units: [(String, Int64)] = [
            ("gb", 1024 * 1024 * 1024),
            ("mb", 1024 * 1024),
            ("kb", 1024),
            ("g", 1024 * 1024 * 1024),
            ("m", 1024 * 1024),
            ("k", 1024)
        ]
        
        for (unit, multiplier) in units {
            if trimmed.hasSuffix(unit) {
                let numberPart = String(trimmed.dropLast(unit.count))

                if let number = Double(numberPart) {
                    return Int64(number * Double(multiplier))
                }
            }
        }
        
        throw ValidationError("Invalid size format: '\(sizeString)'. Use formats like '1024', '200kb', '1mb', or '4gb'")
    }
}
