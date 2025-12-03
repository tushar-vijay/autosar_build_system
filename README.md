# AUTOSAR Build System (Sample Project)

[![CMake](https://img.shields.io/badge/build-CMake-brightgreen.svg)](https://cmake.org)  
[![Language](https://img.shields.io/badge/language-C%20%2F%20CMake-blue.svg)](https://en.wikipedia.org/wiki/C_(programming_language))

## Overview

This repository contains a minimal **AUTOSAR-style** sample project intended to demonstrate a multi-layer C build system using **CMake**. The project is an initial delivery with dummy modules for each AUTOSAR layer to showcase how layers are organized, built into static libraries, and linked into a single executable.

Key layers included:
- **ASW** (Application Software)
- **BSW** (Basic Software)
- **MCAL** (Microcontroller Abstraction Layer)
- **CDD** (Complex Device Driver)

A simple `main.c` calls dummy functions from each layer and prints a sample message on successful run. Example source: `main.c`.

---

## What you get in this repo

- Layer source folders: `asw/`, `bsw/`, `mcal/`, `cdd/` (each containing C sources, headers, and their own `CMakeLists.txt`)  
- Top-level `CMakeLists.txt` that:
  - Configures the project and C standard
  - Adds subdirectories for each layer
  - Builds a `main_exec` executable from `main.c` and links against the layer static libraries.
- Example `main.c` and `main.h`. 
- `.gitignore` with common build artifacts listed.

---

## Project Structure

/

├── asw/ # Application layer (sources + CMake)

├── bsw/ # Basic software layer (sources + CMake)

├── mcal/ # Microcontroller abstraction (sources + CMake)

├── cdd/ # Complex device driver (sources + CMake)

├── CMakeLists.txt # Top-level CMake configuration. 

├── main.c # Example entrypoint. 

├── main.h # Header for main (placeholder).

├── README.md # This file

└── .gitignore # Ignored build files / artifacts.

---

## Build Instructions

### Requirements
- CMake (>= 3.15 recommended)
- C compiler (GCC/Clang on Linux/macOS or MSVC on Windows)
- `build.bat` may be present for quick Windows builds (inspect before running)

### Unix / Linux / macOS (out-of-source build)
```bash
# from project root
mkdir -p build
cd build
cmake ..            # configure
cmake --build .     # build
# run executable
./main_exec
```

### Windows (CMake / build.bat)

- From a Developer Command Prompt or MSYS2/MinGW:

```bash
mkdir build
cd build
cmake .. -G "Visual Studio 16 2019"   # or another appropriate generator
cmake --build .
.\main_exec.exe
```

- Or run the included build.bat if present (review contents first).

## How it is wired (high level)

Each AUTOSAR layer (asw, bsw, mcal, cdd) contains its own CMakeLists.txt that builds a static library (for example: asw_dummy, bsw_dummy, etc.). The top-level CMakeLists.txt calls add_subdirectory(...) for each layer, creates the main_exec target from main.c, and links the layer libraries into the executable. This modular layout mirrors common multi-module embedded project setups. 

main.c demonstrates usage by calling the dummy functions exported by each layer; when run it prints:

```
Sample Build Successful
```

## Development notes & tips

- Keep builds out-of-source (use a build/ folder) to keep the repository clean. .gitignore already excludes common artifacts. 
- To add a new layer: create a folder with sources + CMakeLists.txt that builds a library, add add_subdirectory(<folder>) to the top-level CMakeLists.txt, and add the library to target_link_libraries(main_exec ...). 
- For cross-compilation, add a CMake toolchain file and pass -DCMAKE_TOOLCHAIN_FILE=path/to/toolchain.cmake to cmake.