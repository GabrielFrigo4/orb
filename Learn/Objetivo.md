# OBJECTIVES.md — The Theoretical Foundation of Orb

> **Version:** 1.0 (Concept)
> **Status:** Active Development
> **Domain:** Systems Engineering, High-Performance I/O, Language Design

## 1. Abstract

**Orb** is an experimental backend runtime designed to challenge the current dichotomy in server-side engineering: the trade-off between the safety/speed of systems languages (Rust, C++) and the developer velocity of dynamic scripting languages (Node.js, Python).

Orb implements a **Micro-kernel Architecture** where the "Kernel" is a static Rust binary handling hardware interactions via asynchronous rings (`io_uring`/`IOCP`), and the "Userland" consists of multiple, isolated **Lua 5.5** states ("Orbs") operating under strict capability-based security constraints.

---

## 2. Philosophical Pillars

### 2.1. Mechanism, Not Policy

Orb does not dictate API styles (REST vs GraphQL) or routing patterns. Instead, it provides the highly optimized **mechanisms** (TCP, UDP, Filesystem, Timers) and leaves the **policy** implementation to the Lua userland.

### 2.2. The "Exoskeleton" Metaphor

Orb acts as a rigid, high-performance exoskeleton (Rust) protecting a flexible, organic core (Lua).

- **Rust** handles the heavy lifting: memory management, thread scheduling, and syscalls.
- **Lua** handles the business logic: data transformation, decision trees, and flow control.

### 2.3. Share-Nothing Architecture

Traditional multi-threaded servers suffer from race conditions and complex locking mechanisms (Mutex/RwLock). Orb adopts a **Share-Nothing** approach:

- Each Worker (Orb) has its own isolated memory heap.
- Orbs communicate strictly via message passing (Channels).
- **Result:** Linear scalability across CPU cores with zero lock contention.

---

## 3. Academic & Technical Concepts

### 3.1. Proactive vs. Reactive I/O

Most runtimes (Node.js, Nginx) use a **Reactive** model (`epoll`/`kqueue`): "Tell me when data is ready to be read." This incurs a syscall overhead to check status and another to read data.

Orb targets a **Proactive** (Completion-based) model where supported (`io_uring`, `IOCP`):

- "Here is a buffer. Fill it and tell me when you are done."
- This enables **Zero-Copy** operations on supported hardware and reduces context switching (User/Kernel space transitions).

### 3.2. The Micro-Kernel & Capabilities

Inspired by OS design (like Minix or SeL4), Orb treats Lua scripts as untrusted processes.

- **Standard Lua:** Has `io.open` and `os.execute` (Global access).
- **Orb Lua:** Has **zero** access by default. Capabilities (`fs.read`, `net.listen`) are injected into the Lua State at boot time based on a static Topology (`orb.yaml`). This makes "Supply Chain Attacks" via malicious dependencies significantly harder to execute.

### 3.3. Green Threads & Coroutines

Orb maps M Lua Coroutines onto N OS Threads (M:N Scheduling).

- The Rust Host runs a **Work-Stealing Scheduler** (`Tokio`).
- Lua code is written synchronously (linear style).
- When a Lua script calls `orb.fs.read()`, the Host **yields** the Lua coroutine, processes the I/O asynchronously on the hardware, and **resumes** the coroutine only when data is available.

---

## 4. Memory Management Model

### 4.1. The "Buffer Ownership" Problem

Dynamic languages usually rely on Garbage Collection (GC) for strings, which creates massive overhead in high-throughput I/O.
Orb bypasses the Lua GC for I/O operations using **Host-Managed Buffers**:

1.  **Allocation:** A buffer is allocated in Rust (Stable Heap).
2.  **Borrowing:** A reference (Userdata) is passed to Lua.
3.  **Operation:** The Kernel fills the Rust buffer directly.
4.  **Access:** Lua reads the buffer via a strictly typed API.

- **Benefit:** Reduces memory fragmentation and GC pauses (Stop-the-World).

### 4.2. Custom Allocators

To support long-running processes without fragmentation, Orb utilizes **mimalloc** (Microsoft's allocator) or **jemalloc** as the underlying allocator for both the Rust Host and the Lua States.

---

## 5. The "Standard Library" Strategy

Orb explicitly **removes** the standard Lua libraries:

- `io`: Removed (Blocking I/O is forbidden).
- `os`: Removed (Spawning processes is restricted).
- `package`: Modified (To control module loading).

It replaces them with **`orb-std`**:

- Written entirely in Rust.
- Exposed to Lua via `mlua`.
- Fully asynchronous.
- Type-checked at the boundary.

---

## 6. Performance Targets

Orb is designed to compete with C++ and Rust frameworks, not just interpreted ones.

- **Startup Time:** < 5ms for the Host, < 100µs for a new Orb (Worker).
- **Memory Footprint:** < 5MB for the Host, < 50KB per idle Orb.
- **Throughput:** Saturation of 10GbE network links on commodity hardware.
- **Latency:** Sub-millisecond p99 latency for non-blocking operations.

---

## 7. Roadmap & Modules

### Phase 1: Orb (The Core)

- [x] Conceptual Architecture.
- [ ] Rust Host implementation (Tokio + mlua).
- [ ] YAML Topology Parser.
- [ ] Basic HTTP/TCP Capabilities.

### Phase 2: RFLD (The Data Layer)

- [ ] Embedded database engine (Key-Value/SQLite) optimized for Orb's async architecture.

### Phase 3: RFLF (The Interface)

- [ ] Frontend tooling and bindings (Conceptual).

### Phase 4: The Ecosystem

- [ ] **Native Plugins:** Support for loading `.so`/`.dll` compiled from Rust or Pallene for CPU-bound tasks.

---

## 8. Conclusion

Orb is not just a framework; it is an attempt to redefine the "unit of computation" in backend servers. By moving away from heavy OS processes and towards lightweight, isolated, capability-constrained "Orbs", we can build systems that are simultaneously faster, safer, and easier to maintain.
