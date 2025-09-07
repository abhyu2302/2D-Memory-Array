#Parameterized Memory Controller
Overview

This project implements a parameterized memory subsystem consisting of a controller, datapath, and integrated top module with a testbench. It models a simplified synchronous memory system where read and write operations are performed in a controlled manner, similar to how processors interact with memory.

Features

Parameterized design: configurable rows (R), columns (C), and data width (N)

2D memory array for storage and retrieval

Address decoding from linear address to row/column indices

Valid and ready handshaking signals for synchronization

Testbench for functional verification of read and write operations

Modules
1. Datapath (datapath.v)

Implements the memory array (R x C) storing N-bit data

Handles read and write operations based on control signals

Generates valid signal when data is read successfully

2. Controller (controller.v)

Decodes linear address into row (ar) and column (ac)

Manages request (req), chip select (cs), and read/write (rw)

Provides ready signal to indicate completion of operation

3. Top Module (integration.v)

Connects controller and datapath

Provides unified interface for external access

4. Testbench (testbench.v)

Initializes clock and reset

Performs sequences of write and read operations

Verifies correctness of stored and retrieved data

Project Structure
├── datapath.v       # Memory datapath implementation
├── controller.v     # Memory controller
├── integration.v    # Top-level integration
├── testbench.v      # Testbench for verification
└── README.md        # Project documentation

How It Works

Write Operation: Input data (Qi) is stored at the decoded row and column address.

Read Operation: Data is retrieved (Qa) with valid high when the operation succeeds.

Handshake: The controller raises ready once a request is acknowledged or data is available.

Applications

Understanding memory subsystems and address decoding

Learning synchronous digital design principles

Educational project for controller–datapath interaction
