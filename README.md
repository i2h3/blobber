# Blobber

A fast, memory-efficient command-line tool for generating files filled with random data. Perfect for testing, benchmarking, and creating test datasets of any size.

## Features

- 🚀 **Fast Generation**: Efficiently creates files of any size using chunked processing
- 💾 **Memory Efficient**: Uses only 1MB of RAM regardless of output file size
- 📏 **Flexible Size Formats**: Supports bytes, KB, MB, GB with intuitive syntax
- 📊 **Progress Tracking**: Shows progress for large files (>10MB)
- 🔒 **Cryptographically Secure**: Uses `arc4random_buf()` for high-quality random data
- 🍎 **macOS Optimized**: Built specifically for macOS 15+ with modern APIs

## Installation

### Building from Source

```bash
git clone https://github.com/yourusername/blobber.git
cd blobber
swift build -c release
```

The binary will be available at `.build/release/blobber`.

### Using Swift Package Manager

```bash
swift run blobber [output-path] [size]
```

## Usage

### Basic Syntax

```bash
blobber <output-path> <size>
```

### Size Formats

Blobber supports multiple size formats:

- **Bytes**: `1024`, `2048`
- **Kilobytes**: `500kb`, `1.5k`
- **Megabytes**: `100mb`, `2.5m`
- **Gigabytes**: `5gb`, `1.2g`

### Examples

```bash
# Create a 1KB test file
blobber test.bin 1kb

# Create a 100MB file for performance testing
blobber large-test.dat 100mb

# Create a 2GB file (with progress indicator)
blobber huge-dataset.bin 2gb

# Create a file with exactly 1024 bytes
blobber precise.bin 1024
```

## Use Cases

- **Performance Testing**: Create large files to test I/O performance
- **Storage Testing**: Generate files of specific sizes for filesystem testing
- **Dummy Data**: Create placeholder files for application testing
- **Benchmarking**: Generate consistent test datasets for benchmarking tools
- **Development**: Create mock files for testing file handling logic

## Requirements

- macOS 15.0 or later
- Swift 6.1 or later

## Technical Details

### Memory Usage

Blobber processes files in 1MB chunks, ensuring constant memory usage regardless of output file size. This means you can generate a 10GB file using only ~1MB of RAM.

### Random Data Quality

Uses macOS's `arc4random_buf()` function, which provides cryptographically secure random numbers suitable for testing scenarios where data quality matters.

### Performance

Typical performance on modern macOS systems:
- Small files (<10MB): Instant
- Large files (100MB-1GB): Progress indicator with real-time updates
- Very large files (>1GB): Sustained write speeds limited primarily by storage device

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with [Swift Argument Parser](https://github.com/apple/swift-argument-parser)
- Inspired by the need for a simple, efficient file generation tool on macOS
- @i2h3 originally wrote such tool multiple times by hand in different forms and this project was different in the way that she mostly used GitHub Copilot in agent mode to implement it as an exercise how she can leverage AI in daily work
