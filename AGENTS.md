# 🤖 AGENTS.md — Diretrizes para Agentes de IA no Orb Kernel

Bem-vindo ao repositório **Orb Kernel** (`Personal/Systems/Orb Kernel`). Este documento é a constituição soberana e instrução mandatória para agentes de Inteligência Artificial operando nesta base de código.

---

## 1. Identidade e Papel

O **Orb** é um micro-kernel assíncrono projetado em Rust para orquestrar trabalhadores leves em Lua 5.5+, com isolamento baseado em capacidades (Capabilities YAML) e I/O não-bloqueante nativo (`io_uring`, `kqueue`, `IOCP`).

- **Stack:** Rust (Async runtime), Lua 5.5+, POSIX.1-2024 / BSD / Linux / Windows.
- **Foco:** Baixa latência, paralelismo real, segurança por capabilities declarativas e FFI sem overhead.

---

## 2. Regras Críticas Soberanas

1. **Separação Kernel / Userland:** O micro-kernel Rust gerencia hardware, concorrência e IPC; a lógica de aplicação vive nos scripts Lua dos trabalhadores.
2. **Invariante Hermetismo de Produção:** O runtime do Orb nunca depende de `.agents/`. A deleção de `.agents/` deixa o repositório 100% autônomo.
3. **Invariante Out-of-the-Box:** Modos octais canônicos no Git Index (`0755` para scripts/hooks, `0644` para fontes e documentação).
4. **Segurança por Capabilities:** Nenhuma rotina Lua deve acessar I/O ou recursos sem declaração explícita no manifesto de capacidades.
5. **Zero Cruft:** Proibição de bibliotecas pesadas e dependências fantasmas.
6. **Commits Semânticos:** Mensagens padronizadas no formato `<type>(<scope>): <descrição>`.

---

## 3. Boy Scout Rule

Sempre deixe o acampamento mais limpo do que encontrou:

- [ ] Mantenha títulos de documentação com badges vetoriais sem excesso de emojis.
- [ ] Valide formatação com `make lint` e `make format`.

---

## 4. Comandos de Verificação Rápidos

| Comando       | Descrição                                           |
| :------------ | :-------------------------------------------------- |
| `make help`   | Exibe o menu interativo com alvos disponíveis       |
| `make format` | Formata fontes Rust (rustfmt) e Markdown (Prettier) |
| `make lint`   | Valida conformidade de formatação                   |
| `make hooks`  | Ativa os githooks locais com permissões 0755        |
| `make ci`     | Executa pipeline de validação de qualidade          |

---

## 5. Referências Obrigatórias

- [Documentação Arquitetural](README.md)
- [Objetivo do Micro-Kernel](Learn/Objetivo.md)
- [Regras de Agentes](.agents/rules/principles.md)
