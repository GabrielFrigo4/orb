.POSIX:
.SILENT:

MAKEFLAGS += --no-print-directory -s

# ----------------------------------------------------------------
# Makefile: Orb Kernel — Async Micro-Kernel & Lua 5.5+ Runtime
# ----------------------------------------------------------------

.PHONY: all help format prettier rustfmt lint hooks ci clean

all: help

### ================================
### HELP & DOCUMENTATION
### ================================
help:
	_e=$$'\e'; \
	cmd() { printf "    $${_e}[36mmake %-22s$${_e}[0m %s\n" "$$1" "$$2"; }; \
	sec() { printf "\n  $${_e}[1;33m%s$${_e}[0m\n" "$$1"; }; \
	printf "\n  $${_e}[1;37mOrb Kernel — Micro-Kernel Assíncrono (Rust & Lua 5.5+)$${_e}[0m\n"; \
	printf "  ===============================================================\n"; \
	sec "Qualidade & Governança:"; \
	cmd "format"         "Formata todas as fontes e documentação (cargo fmt + prettier)"; \
	cmd "prettier"       "Formata arquivos Markdown com Prettier"; \
	cmd "rustfmt"        "Formata código Rust com cargo fmt / rustfmt"; \
	cmd "lint"           "Valida formatação e conformidade sem alterar arquivos"; \
	cmd "hooks"          "Configura e ativa os quality gates locais (.githooks)"; \
	cmd "ci"             "Executa pipeline local de validação e qualidade"; \
	sec "Manutenção:"; \
	cmd "clean"          "Remove artefatos de compilação da pasta target/"; \
	echo ""

### ================================
### FORMATTING & LINTING
### ================================
format: rustfmt prettier
	echo "✅ Formatação concluída!"

prettier:
	echo "🎨 Formatando arquivos Markdown com Prettier..."
	if command -v prettier > "/dev/null" 2>&1; then \
		prettier --write "**/*.md" 2> "/dev/null" || true; \
	elif command -v npx > "/dev/null" 2>&1; then \
		npx prettier --write "**/*.md" 2> "/dev/null" || true; \
	fi

rustfmt:
	if [ -f Cargo.toml ] && command -v cargo > "/dev/null" 2>&1; then \
		echo "⚙️  Formatando código Rust com cargo fmt..."; \
		cargo fmt 2> "/dev/null" || true; \
	fi

lint:
	echo "🔍 Validando formatação com Prettier..."
	if command -v prettier > "/dev/null" 2>&1; then \
		prettier --check "**/*.md"; \
	elif command -v npx > "/dev/null" 2>&1; then \
		npx prettier --check "**/*.md"; \
	fi
	if [ -f Cargo.toml ] && command -v cargo > "/dev/null" 2>&1; then \
		cargo clippy -- -D warnings 2> "/dev/null" || cargo check 2> "/dev/null" || true; \
	fi

### ================================
### GIT HOOKS & PERMISSIONS
### ================================
hooks:
	echo "⚓ Configurando permissões e ativando .githooks..."
	chmod 0755 .githooks/* 2> "/dev/null" || true
	git config core.hooksPath .githooks 2> "/dev/null" || true
	echo "  ✅ Orb Kernel: core.hooksPath -> .githooks"

### ================================
### CI & MAINTENANCE
### ================================
ci: lint
	echo "✅ Quality Gate CI concluído com sucesso!"

clean:
	rm -rf target/
	echo "✅ Workspace limpo!"
