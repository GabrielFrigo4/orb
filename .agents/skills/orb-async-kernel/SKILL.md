---
name: orb-async-kernel
description: >-
    Runbook cognitivo e guia de arquitetura para o micro-kernel assíncrono Orb.
    Use ao estender o núcleo em Rust, implementar primitivas de I/O assíncrono nativo (io_uring, kqueue, IOCP),
    configurar isolamento de segurança baseado em capacidades YAML ou gerenciar workers Lua 5.5+.
---

# Orb Async Micro-Kernel Runbook

Este runbook instrui agentes de IA sobre as regras arquiteturais e de concorrência do **Orb Kernel** (`Personal/Systems/Orb Kernel`).

---

## 1. Arquitetura Orientada a Capacidades

No Orb, nenhum worker em Lua possui permissão para executar chamadas de sistema indiscriminadas:

1. **Manifesto de Capacidades (YAML):** Cada trabalhador declara estritamente os descritores de arquivo, portas de rede e limites de memória autorizados.
2. **Contenção no Micro-Kernel:** O núcleo Rust intercepta toda tentativa de I/O e valida contra a tabela de permissões do worker antes de despachar a operação para o subsistema do sistema operacional.

---

## 2. Motores de I/O Assíncrono Multiplataforma

O Kernel seleciona o backend de maior desempenho por compilação condicional:

| Plataforma  | Backend Nativo | Destaque                                             |
| :---------- | :------------- | :--------------------------------------------------- |
| **Linux**   | `io_uring`     | Zero syscall overhead por submissão de anel em batch |
| **FreeBSD** | `kqueue`       | Notificação rápida de eventos de socket e vnode      |
| **Windows** | `IOCP`         | Portas de conclusão de I/O nativas Win32             |

---

## 3. Isolamento de Estado Lua (L-States)

- Cada trabalhador executa em um `lua_State` totalmente isolado, sem memória compartilhada direta.
- A comunicação entre trabalhadores ocorre via canais de mensagens protegidos (_message passing_) orquestrados pelo micro-kernel Rust.
