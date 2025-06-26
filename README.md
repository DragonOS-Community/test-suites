# DragonOS Test Suites

[![Build Status](https://cnb.cool/DragonOS-Community/test-suites/-/badge/git/latest/ci/status/tag_push
)](https://cnb.cool/DragonOS-Community/test-suites/-/badge/git/latest/ci/status/tag_push
)

This repository contains automated test suite compilation infrastructure for DragonOS, designed to build and package test programs for operating system validation and verification.

## Overview

The DragonOS Test Suites repository serves as a centralized build system for various test frameworks and suites that validate DragonOS functionality. Currently, it focuses on building syscall tests derived from the gVisor project, providing comprehensive system call compatibility testing.

## Repository Structure

```
test-suites/
├── gvisor/                     # gVisor syscall tests build environment
│   ├── Dockerfile             # Build environment container
│   ├── compile-syscall-test.sh # Build script for syscall tests
│   └── run-in-docker.sh       # Docker execution helper
├── .cnb.yml                   # CNB CI/CD configuration
├── .github/                   # GitHub Actions workflows
└── README.md                  # This file
```

## How It Works

### Build Process

1. **Source Acquisition**: The build system clones the DragonOS-specific gVisor fork from the `dragonos/release-20250616.0` branch
2. **Environment Setup**: Uses a Ubuntu 22.04-based Docker container with all necessary build dependencies
3. **Compilation**: Builds gVisor syscall tests using Bazel build system with native test tags
4. **Packaging**: Creates compressed archives (.tar.xz) of the compiled test binaries
5. **Distribution**: Uploads the test packages to release artifacts for easy download

### Supported Test Suites

#### gVisor Syscall Tests

The primary test suite currently supported builds comprehensive system call tests from gVisor's test framework. These tests validate:

- System call compatibility and behavior
- Edge cases and error handling
- Performance characteristics
- Security boundaries

The tests are sourced from: [gVisor Linux syscalls tests](https://cnb.cool/DragonOS-Community/gvisor/-/tree/dragonos/release-20250616.0/test/syscalls/linux)

## Getting Started

### Downloading Pre-built Test Binaries

The easiest way to get the test suites is to download pre-built binaries from our releases:

1. Visit the [CNB releases page](https://cnb.cool/DragonOS-Community/test-suites/)
2. Download the latest `gvisor-syscalls-tests.tar.xz` package
3. Extract and run tests on your DragonOS workspace

### Building from Source

If you want to build the tests yourself:

```bash
# Clone this repository
git clone https://github.com/DragonOS-Community/test-suites.git
cd test-suites

# Build using Docker
cd gvisor
docker build -t gvisor-build-env .
bash run-in-docker.sh
```

### Running Tests

After downloading the test package, you need to deploy it to your DragonOS repository:

```bash
# Navigate to your DragonOS repository
cd /path/to/your/DragonOS

# Create the tests directory if it doesn't exist
# Note: If this directory doesn't exist, you need to compile DragonOS first
mkdir -p bin/sysroot/tests

# Extract the test package to the correct location
tar -xJf gvisor-syscalls-tests.tar.xz -C bin/sysroot/tests

# The tests are now available in bin/sysroot/tests/syscalls/
ls bin/sysroot/tests/syscalls/
```

**Important Note**: If the `bin/sysroot/tests` directory doesn't exist in your DragonOS repository, you need to compile DragonOS at least once to generate the necessary directory structure.

After deployment, you can run individual tests:

```bash
# Navigate to the tests directory
cd bin/sysroot/tests/syscalls

# Run individual tests
./read_test
# ... and many more
```

## CI/CD Pipeline

This repository uses CNB (cnb.cool) for continuous integration and delivery. The pipeline:

- **Triggers**: Automatically builds on release tag pushes
- **Environment**: Uses 32-core runners for fast compilation
- **Artifacts**: Generates and uploads test packages to releases
- **Caching**: Optimizes build times through Docker layer caching

The build configuration is defined in `.cnb.yml` and supports parallel compilation for faster build times.

## Contributing

We welcome contributions to expand the test suite coverage:

1. **Adding New Test Suites**: Create new directories following the gVisor example
2. **Improving Build Scripts**: Enhance compilation efficiency and cross-platform support
3. **Documentation**: Help improve setup and usage documentation
4. **Bug Reports**: Report issues with test compilation or execution

### Development Workflow

1. Fork this repository
2. Create a feature branch
3. Add your test suite or improvements
4. Update documentation as needed
5. Submit a pull request

## Acknowledgments

**Special thanks to [CNB (cnb.cool)](https://cnb.cool) for providing high-speed, reliable build infrastructure that makes this automated testing pipeline possible.**

The CNB platform provides:
- Fast, scalable build runners (32 cores and 64G RAM for free)
- Reliable artifact storage and distribution
- Excellent developer experience with modern CI/CD features
- Support for complex build workflows like our multi-stage compilation process

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Links

- **GitHub Repository**: https://github.com/DragonOS-Community/test-suites
- **CNB Repository**: https://cnb.cool/DragonOS-Community/test-suites/
- **DragonOS Project**: https://github.com/DragonOS-Community/DragonOS
- **gVisor Source**: https://cnb.cool/DragonOS-Community/gvisor/-/tree/dragonos/release-20250616.0/test/syscalls/linux

---

For questions, issues, or contributions, please visit our [GitHub repository](https://github.com/DragonOS-Community/test-suites) or open an issue.

