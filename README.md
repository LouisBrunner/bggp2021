# Entry for the Binary Golf Grand Prix 2021

This repository contains some prototypes I developed for BGGP 2021 (which I didn't participate in).

## Usage

Requires Docker to be installed. Run `./build.sh`, the binary will be available as `build/pog.zip`.

### Development

You can use `./start.sh` to start the Docker image and `make all`, `make clean` and `make re` to manage the development workflow.

`make audit` to check if the file fits the criteria.

## Content

### ELF

The binary can be used as a x86 ELF binary on Linux 32bit.
It will return `2` as a status code.

### ZIP

The binary can be unzipped as a ZIP archive containing a single file.
