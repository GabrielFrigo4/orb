# 🤖 Orb Kernel — AI Agent Briefing

> Micro-kernel assíncrono projetado em Rust para orquestrar trabalhadores leves em Lua 5.5+, com isolamento baseado em capacidades e I/O não-bloqueante nativo.

---

## 🧭 Identidade e Papel

O **Orb** é um micro-kernel assíncrono projetado em Rust para orquestrar trabalhadores leves em Lua 5.5+, com isolamento baseado em capacidades (Capabilities YAML) e I/O não-bloqueante nativo (`io_uring`, `kqueue`, `IOCP`).

- **Stack Primária:** Rust (Async runtime), Lua 5.5+, POSIX.1-2024 / BSD / Linux / Windows
- **Foco:** Baixa latência, paralelismo real, segurança por capabilities declarativas e FFI sem overhead

---

## 📁 Estrutura Canônica de Arquivos

```text
Orb Kernel/
├── Learn/                     # Material de estudo e especificações conceituais
├── .agents/                   # Governança e runbooks locais de IA
├── AGENTS.md                  # Constituição e briefing para agentes de IA
├── LICENSE                    # Licença MIT
├── Makefile                   # Orquestrador POSIX silencioso
├── PRINCIPLES.md              # 22 Princípios de Engenharia aplicados
├── README.md                  # Documentação arquitetural do micro-kernel
└── TODO.md                    # Roadmap de evolução técnica
```

---

## ⚠️ Regras Críticas para Agentes de IA

1. **Separação Kernel / Userland:** O micro-kernel Rust gerencia hardware, concorrência e IPC; a lógica de aplicação vive nos scripts Lua dos trabalhadores.
2. **Invariante Hermetismo de Produção:** O runtime do Orb nunca depende de `.agents/`. A deleção de `.agents/` deixa o repositório 100% autônomo.
3. **Invariante Out-of-the-Box:** Modos octais canônicos no Git Index (`0755` para scripts/hooks, `0644` para fontes e documentação).
4. **Segurança por Capabilities:** Nenhuma rotina Lua deve acessar I/O ou recursos sem declaração explícita no manifesto de capacidades.
5. **Zero Cruft:** Proibição de bibliotecas pesadas e dependências fantasmas.
6. **Commits Semânticos:** Mensagens padronizadas no formato `<type>(<scope>): <descrição>`.

---

## 🛡️ Regra da Proatividade e Correção Contínua (Boy Scout Rule)

O agente de IA atua de forma proativa na manutenção e aplicação dos padrões canônicos deste repositório.

Ao identificar linhas ou artefatos fora dos padrões estabelecidos:

1. **Notificar concisamente** o usuário sobre o ajuste realizado.
2. **Corrigir a inconformidade**, aplicando o padrão correspondente:
    - **Comentários Narrativos:** Eliminar comentários óbvios que apenas narram código executável.
    - **Banners Estruturais:** Ajustar réguas para exatamente 64 hífens no topo ou 32 caracteres com `### ` no corpo.
    - **Portabilidade POSIX:** Substituir bashismos (`[[ ]]`, `&>`, arrays, `source`) por sintaxe estrita POSIX `/bin/sh`.
    - **Shebang Universal:** Garantir sempre `#!/usr/bin/env sh` ou `#!/usr/bin/env python3`.
    - **Sequências ANSI & Escapes:** Não use octais (`\033`, `\001`) para caracteres ou escapes. Use `[ -t 1 ] && echo -n $'\e...'` ou notação hexadecimal (`\x01`, `\x1b`). Octal é exclusivo para permissões POSIX (`chmod 0755`, `chmod 0644`, `umask`).
    - **Redirecionamento Seguro:** Envolver destinos em aspas duplas (ex: `> "/dev/null" 2>&1`).
    - **Makefiles:** Assegurar cabeçalho `.POSIX: .SILENT:`, `MAKEFLAGS += --no-print-directory -s`, alinhamento estético de variáveis e zero `@` redundante.
    - **Permissões Canônicas:** Aplicar 4 dígitos octais (`chmod 0755`, `chmod 0644`, `chmod 0700`, `chmod 0600`).
    - **Invariante Out-of-the-Box:** Garantir modos octais corretos no Git Index e auto-cura em tempo de execução sem requerer intervenção manual pós-clone.
    - **Emissão Semântica de UI:** Substituir `echo` avulsos com emojis pelas rotinas canônicas `_ui_*`.
    - **Antifragilidade & Resiliência:** Resolução ativa de caminhos em cascata, auto-cura de permissões (0600 em chaves/segredos) e validação defensiva de pré-requisitos.
    - **Curadoria Cognitiva:** Capturar decisões estruturais e regras tácitas em skills locais compactas (`.agents/skills/`), mantendo-as atualizadas e expurgando ruído obsoleto.
    - **Refatoração Sem Legado:** Expurgar aliases obsoletos, variáveis mortas e shims de compatibilidade em renomeações.
    - **Elevação Antifrágil & Shift Seguro:** Usar o bloco explícito `if [ "$(id -u)" -ne 0 ]` para resolução de `ELEVATE` (evitando término fatal sob `set -e` como root) e proteger todo comando `shift` com validação prévia de parâmetros (`[ "$#" -ge N ] && shift N`).
    - **Simetria de Documentação:** Mover regras ou invariantes universais documentadas erroneamente em sub-membros específicos para o documento de arquitetura do grupo correspondente, eliminando falsas assimetrias.

---

## 🚀 Comandos de Verificação Rápida (Quality Gates)

| Comando         | Finalidade Operacional                              |
| :-------------- | :-------------------------------------------------- |
| `make help`     | Exibe o menu interativo com alvos disponíveis       |
| `make format`   | Formata fontes Rust (rustfmt) e Markdown (Prettier) |
| `make rustfmt`  | Formata fontes Rust com rustfmt                     |
| `make prettier` | Formata arquivos Markdown com Prettier              |
| `make lint`     | Valida conformidade de formatação                   |
| `make hooks`    | Ativa os githooks locais com permissões `0755`      |
| `make ci`       | Executa pipeline de validação de qualidade          |
| `make clean`    | Remove diretórios temporários e caches              |

---

## 📖 Referências Obrigatórias

Antes de qualquer modificação neste ecossistema, consulte:

- [README.md](README.md) — Documentação arquitetural do micro-kernel
- [Learn/Objetivo.md](Learn/Objetivo.md) — Objetivo e visão do micro-kernel
- [PRINCIPLES.md](PRINCIPLES.md) — Os 22 Princípios de Engenharia Soberanos
- [TODO.md](TODO.md) — Roadmap de evolução técnica
- [LICENSE](LICENSE) — Licença MIT
- [.agents/rules/principles.md](.agents/rules/principles.md) — Regra de Princípios
- [.agents/skills/orb-async-kernel/SKILL.md](.agents/skills/orb-async-kernel/SKILL.md) — Runbook do Micro-Kernel Assíncrono
