# Orb

## The Async Micro-Kernel for Lua
 **Orb** is a next-generation backend runtime that combines the raw performance of **Rust** asynchronous I/O with the lightweight scripting capabilities of **Lua 5.5**.

 Unlike traditional monolithic frameworks, Orb isolates your business logic into secure, capability-constrained spheres ("Orbs"), managed by a high-throughput Rust host.

---

## ✨ Key Features
 * **🦀 Powered by Rust & io_uring:** Built on top of `Tokio` and `io_uring` (Linux) / `IOCP` (Windows) for true zero-cost asynchronous I/O.
 * **🌑 Micro-Kernel Architecture:** Your code runs inside isolated Lua States (~20KB footprint). One crashing worker never takes down the whole server.
 * **🛡️ Capability-Based Security:** Defined via YAML. An Orb cannot touch the disk, network, or environment variables unless explicitly granted by the shell topology.
 * **⚡ Zero-Block Scripting:** Write linear, synchronous-looking Lua code that is executed asynchronously by the Rust host. No callback hell.
 * **📦 Rust-Native StdLib:** We stripped the bloated Lua standard library and replaced it with a custom, high-performance Rust implementation focused on Backend needs.

---

## Why Orb?
 Most backend frameworks force you to choose between **safety/speed** (Rust, Go) and **development speed** (Node.js, Python).

 **Orb gives you both.** It acts as an exoskeleton:

 * **The Core (Rust):** Handles memory safety, thread scheduling, and hardware access at bare-metal speeds.
 * **The Logic (Lua):** Handles business rules with the simplicity and flexibility of a dynamic language.

 In Orb, you don't just "run a script". You define a **topology** of isolated workers. An authentication worker physically cannot read your database files. A logging worker cannot open a network port. It is secure by design.

---

# Orb 🌑
> **Gravitational speed. Perfect isolation.**

A capability-based micro-kernel runtime for Lua 5.5, built in Rust.

## 📖 Introduction
 Orb fills the gap between rigid systems languages and heavy monolithic runtimes. It allows you to build high-performance backends using **Lua** for logic and **Rust** for heavy lifting, orchestrated by a strict **YAML** topology.

## 🚀 Quick Start
 ```bash
 # Install Orb
 cargo install orb-cli

 # Create a new universe
 orb new my-api

 # Define your spheres in orb.yaml and run
 orb start
 ```

## 🏗 Architecture
 * **Host:** Rust (Static binary, Async Runtime)
 * **Guest:** Lua 5.5 (Isolated States, No standard IO)
 * **I/O:** io_uring / IOCP / kqueue (OS Native)

## 🛡️ The "Orb" Philosophy
 Every worker is an Orb—a sealed environment.
 Permissions are granted, not assumed.

 ```yaml
 orbs:
   - name: "public_gateway"
     capabilities: ["net.tcp"]
   - name: "db_writer"
     capabilities: ["fs.write"]
 ```

## 🤝 Contributing
 * Gabriel Frigo
 * Felipe
