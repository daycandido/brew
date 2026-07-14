#!/usr/bin/env bash

# =============================================================================
# SETUP CLAUDE CODE — 12 Skills & Agents
# Day Candido × AxialMind
# Roda uma vez. Cria tudo.
# =============================================================================

set -e

# ── CORES ──
GREEN='\033[0;32m'; BLUE='\033[0;34m'; PURPLE='\033[0;35m'
ORANGE='\033[0;33m'; RED='\033[0;31m'; BOLD='\033[1m'; NC='\033[0m'

log()    { echo -e "${GREEN}✓${NC} $1"; }
info()   { echo -e "${BLUE}→${NC} $1"; }
warn()   { echo -e "${ORANGE}⚠${NC}  $1"; }
header() { echo -e "\n${BOLD}${PURPLE}$1${NC}"; echo "$(printf '─%.0s' {1..60})"; }
boom()   { echo -e "${ORANGE}★${NC} $1"; }

echo ""
echo -e "${BOLD}${PURPLE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${PURPLE}║   CLAUDE CODE SETUP — 12 Skills & Agents                ║${NC}"
echo -e "${BOLD}${PURPLE}║   Iniciante × Intermediário × Avançado × Disruptivo     ║${NC}"
echo -e "${BOLD}${PURPLE}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

# =============================================================================
# PREFLIGHT
# =============================================================================

header "Verificando dependências"

# Node.js
if ! command -v node &> /dev/null; then
  echo -e "${RED}✗ Node.js não encontrado.${NC}"
  echo "  Instale em: https://nodejs.org (versão 18+)"
  exit 1
fi
NODE_VERSION=$(node --version)
log "Node.js $NODE_VERSION"

# npm
if ! command -v npm &> /dev/null; then
  echo -e "${RED}✗ npm não encontrado.${NC}"; exit 1
fi
log "npm $(npm --version)"

# git
if ! command -v git &> /dev/null; then
  warn "git não encontrado. Alguns skills dependem do git para funcionar."
else
  log "git $(git --version | awk '{print $3}')"
fi

# python3
if ! command -v python3 &> /dev/null; then
  warn "python3 não encontrado. Os hooks de captura de erros precisam dele."
else
  log "python3 $(python3 --version | awk '{print $2}')"
fi

# =============================================================================
# ESTRUTURA DE DIRETÓRIOS
# =============================================================================

header "Criando estrutura de diretórios"

BASE="$HOME/.claude"
DIRS=(
  "$BASE/skills/standup"
  "$BASE/skills/commit"
  "$BASE/skills/mode-dev"
  "$BASE/skills/mode-review"
  "$BASE/skills/mode-write"
  "$BASE/skills/evolve"
  "$BASE/skills/propagate-decision"
  "$BASE/agents"
  "$BASE/hooks"
  "$BASE/evolution"
  "$BASE/hive"
)

for d in "${DIRS[@]}"; do
  mkdir -p "$d"
  log "Criado: $d"
done

# =============================================================================
# INICIANTE 01 — DAILY STANDUP
# =============================================================================

header "Iniciante 01 — Daily Standup"

cat > "$BASE/skills/standup/SKILL.md" << 'SKILL_EOF'
---
name: standup
description: Gera update de standup diário automaticamente. Use quando o usuário pedir standup, update do dia, o que fiz hoje, ou daily. Lê git log, arquivos modificados e resumo do projeto.
allowed-tools: Bash, Read, Glob
---

# Daily Standup Generator

Ao ser invocado, execute esta sequência sem pedir confirmação:

## 1. Coleta de dados

Execute os seguintes comandos bash:

- `git log --oneline --since="yesterday" --author="$(git config user.name)"`
- `git diff --stat HEAD~5..HEAD 2>/dev/null | tail -5`
- `git status --short`

Se não houver repositório git, leia os arquivos modificados nas últimas 24h:

- `find . -newer ~/.claude/last-standup -type f -not -path '*/node_modules/*' 2>/dev/null | head -20`

## 2. Formato de saída

Gere o standup EXATAMENTE neste formato (sem introdução, sem explicação):

---

**ONTEM**
[lista concisa do que foi feito, máx 4 itens, primeira pessoa]

**HOJE**
[inferir próximos passos naturais do que foi feito, máx 3 itens]

**BLOQUEIOS**
[se não houver, escreva: Nenhum]

## 3. Regras de escrita

- Linguagem de ação: "Implementei", "Corrigi", "Refatorei", "Revisei"
- Sem jargão técnico desnecessário
- Sem emojis
- Máximo 3 linhas por seção
- Se não tiver dados suficientes, peça para o usuário completar o que faltou
SKILL_EOF
log "standup/SKILL.md criado"

# =============================================================================
# INICIANTE 02 — COMMIT MESSAGE WRITER
# =============================================================================

header "Iniciante 02 — Commit Message Writer"

cat > "$BASE/skills/commit/SKILL.md" << 'SKILL_EOF'
---
name: commit
description: Gera mensagem de commit semântica no padrão Conventional Commits lendo o git diff staged. Use quando o usuário pedir mensagem de commit, escrever commit, ou "o que coloco no commit".
allowed-tools: Bash
---

# Commit Message Writer

Execute sem pedir confirmação:

## 1. Lê o diff

`git diff --staged`
Se não houver nada staged: `git diff HEAD~1 HEAD`

## 2. Classifica o tipo

Escolha o tipo correto:

- `feat`: nova funcionalidade
- `fix`: correção de bug
- `refactor`: mudança sem alterar comportamento externo
- `docs`: apenas documentação
- `test`: adição/ajuste de testes
- `chore`: build, deps, config
- `perf`: melhoria de performance
- `style`: formatação sem lógica

## 3. Formato de saída

Gere APENAS a mensagem, pronta para copiar:

```
tipo(scope): descrição imperativa em até 72 chars

Body opcional: explica o POR QUÊ da mudança se não for óbvio.
Máximo 3 linhas.

Closes #NNN (se identificar referência a issue no código)
```

Regras de escrita:

- Imperativo: "add", "fix", "remove" — nunca "added", "fixing"
- Sem ponto final na linha de subject
- Scope = módulo/componente afetado (ex: auth, api, ui)
- Se a mudança for trivial, omita o body
SKILL_EOF
log "commit/SKILL.md criado"

# =============================================================================
# INICIANTE 03 — CONTEXT LOADER POR PAPEL
# =============================================================================

header "Iniciante 03 — Context Loader por Papel"

cat > "$BASE/skills/mode-dev/SKILL.md" << 'SKILL_EOF'
---
name: mode-dev
description: Ativa modo de desenvolvimento: carrega preferências de código, padrões de arquitetura e foco em implementação. Use quando o usuário disser "modo dev", "vou codar", "começa a implementação".
allowed-tools: Read
---

Leia o arquivo `dev-context.md` neste diretório e aplique todas as instruções.

Confirme com: "Modo DEV ativado. Foco: implementação e padrões de código."
SKILL_EOF

cat > "$BASE/skills/mode-dev/dev-context.md" << 'CTX_EOF'
# Contexto: Modo Desenvolvimento

**Foco:** implementação rápida e correta

**Regras ativas:**

- Funções com mais de 30 linhas: refatora antes de continuar
- Nunca commitar sem testes para lógica de negócio nova
- Nomes em inglês para código, português para comentários

**O que NÃO fazer neste modo:**

- Não sugerir refatorações não solicitadas
- Não reescrever o que já funciona
- Focar no que foi pedido, entregar rápido

**Edite este arquivo** com suas preferências reais de desenvolvimento.
CTX_EOF

cat > "$BASE/skills/mode-review/SKILL.md" << 'SKILL_EOF'
---
name: mode-review
description: Ativa modo de revisão de código: foco em qualidade, segurança e padrões. Use quando o usuário disser "modo review", "vou revisar", "vai analisar código".
allowed-tools: Read
---

Leia o arquivo `review-context.md` neste diretório e aplique todas as instruções.

Confirme com: "Modo REVIEW ativado. Foco: qualidade, segurança e padrões."
SKILL_EOF

cat > "$BASE/skills/mode-review/review-context.md" << 'CTX_EOF'
# Contexto: Modo Revisão

**Foco:** qualidade, segurança, manutenibilidade

**Checklist de revisão:**

- Segurança: inputs validados, sem hardcoded secrets, auth correto
- Performance: sem N+1 queries, loops desnecessários
- Legibilidade: nomes claros, funções pequenas, comentários úteis
- Testes: cobertura adequada para lógica crítica

**Tom:** construtivo, específico, acionável. Mostre o código atual e o melhorado.

**Edite este arquivo** com seus critérios reais de revisão.
CTX_EOF

cat > "$BASE/skills/mode-write/SKILL.md" << 'SKILL_EOF'
---
name: mode-write
description: Ativa modo de escrita técnica: foco em documentação, clareza e audiência. Use quando o usuário disser "modo escrita", "vou escrever docs", "documenta isso".
allowed-tools: Read
---

Leia o arquivo `write-context.md` neste diretório e aplique todas as instruções.

Confirme com: "Modo ESCRITA ativado. Foco: documentação clara e objetiva."
SKILL_EOF

cat > "$BASE/skills/mode-write/write-context.md" << 'CTX_EOF'
# Contexto: Modo Escrita Técnica

**Audiência padrão:** desenvolvedores do time com contexto médio do projeto

**Tom:** direto, técnico mas acessível, sem jargão desnecessário

**Formato preferido:**

- Títulos H2 para seções principais
- Exemplos de código sempre que relevante
- Tabelas para comparações
- Listas para passos sequenciais

**O que evitar:**

- Frases de introdução genéricas
- Conclusões que repetem o que foi dito
- Jargão corporativo

**Edite este arquivo** com suas preferências de escrita.
CTX_EOF

log "mode-dev, mode-review, mode-write criados"

# =============================================================================
# INTERMEDIÁRIO 01 — TRIAGE DE ISSUES
# =============================================================================

header "Intermediário 01 — Triage de Issues"

mkdir -p "$HOME/.claude-project-templates/triage"

cat > "$HOME/.claude-project-templates/triage/SKILL.md" << 'SKILL_EOF'
---
name: triage
description: Prioriza issues abertas do GitHub com análise estruturada de impacto, urgência e esforço. Use quando o usuário pedir triage, priorização, ranking de issues ou backlog review.
context: fork
agent: Explore
allowed-tools: Read, Glob, Grep
---

# Issue Triage Framework

Execute em sequência sem interrupção:

## Fase 1: Coleta

Usando o GitHub MCP disponível:

1. Liste todas as issues abertas do repositório atual
2. Para cada issue, capture: título, labels, assignees, data de criação, número de comentários
3. Leia o CLAUDE.md do projeto para entender prioridades do produto

## Fase 2: Análise (para cada issue)

Classifique em uma matriz ICE:

- **Impact** (1-10): quanto valor entrega ao usuário/negócio?
- **Confidence** (1-10): quão certo estamos que vai funcionar?
- **Ease** (1-10): quão fácil de implementar?
- **ICE Score** = (Impact × Confidence × Ease) / 3

## Fase 3: Saída

Devolva em formato de tabela markdown:

|#|Issue|Score|Impacto|Confiança|Facilidade|Racional|
|-|-----|-----|-------|---------|----------|--------|

Seguido de:
**Top 3 para fazer agora:** [justificativa em 2 linhas cada]
**1 que pode fechar sem fazer:** [com motivo]
**Dependências identificadas:** [issues que bloqueiam outras]
SKILL_EOF

info "Template de triage salvo em: ~/.claude-project-templates/triage/"
info "Para usar num projeto: cp -r ~/.claude-project-templates/triage .claude/skills/"

# =============================================================================
# INTERMEDIÁRIO 02 — DOC SYNC
# =============================================================================

header "Intermediário 02 — Doc Sync"

mkdir -p "$HOME/.claude-project-templates/doc-sync"

cat > "$HOME/.claude-project-templates/doc-sync/SKILL.md" << 'SKILL_EOF'
---
name: doc-sync
description: Detecta funções e módulos sem documentação no repositório e gera docstrings/JSDoc automaticamente. Use quando o usuário pedir para documentar o código, sincronizar docs, ou "o que está sem documentação".
context: fork
agent: Explore
allowed-tools: Glob, Grep, Read, Write
---

# Doc Sync — Análise e Geração

Execute em sequência no subagente Explore:

## Fase 1: Inventário

1. Use Glob para mapear todos os arquivos de código:
   `**/*.{js,ts,py,jsx,tsx}` — exclua `node_modules`, `dist`, `build`
2. Para cada arquivo, use Grep para identificar funções sem doc:
   - Python: `def ` sem `"""` na linha seguinte
   - JS/TS: `function ` ou `=>` sem `/** ` antes
3. Gere um relatório: N arquivos, M funções sem doc

## Fase 2: Geração

Para cada função sem documentação:

1. Leia o corpo da função para entender o que faz
2. Gere a docstring no formato correto da linguagem:
   - Python: Google Style docstring com Args e Returns
   - JS/TS: JSDoc com @param, @returns, @example
3. Insira diretamente no arquivo, acima da assinatura da função

## Fase 3: Relatório final

Retorne ao contexto principal:

- Quantos arquivos foram modificados
- Quantas funções documentadas
- Lista dos arquivos alterados com contagem por arquivo
SKILL_EOF
log "doc-sync template criado"

# =============================================================================
# INTERMEDIÁRIO 03 — RELEASE NOTES
# =============================================================================

header "Intermediário 03 — Release Notes Generator"

mkdir -p "$HOME/.claude-project-templates/release-notes"

cat > "$HOME/.claude-project-templates/release-notes/SKILL.md" << 'SKILL_EOF'
---
name: release-notes
description: Gera release notes estruturadas lendo commits desde a última tag. Use quando o usuário pedir release notes, changelog, notas de versão, ou "o que mudou desde a última release".
context: fork
agent: Explore
allowed-tools: Bash, Read, Write
---

# Release Notes Generator

## 1. Coleta

`git describe --tags --abbrev=0` → última tag
`git log [última-tag]..HEAD --oneline --no-merges`

Se não houver tags: `git log --oneline -50`

## 2. Classifica e agrupa

Separe os commits por prefixo:

- `feat:` → Novas Funcionalidades
- `fix:` → Correções
- `perf:` → Melhorias de Performance
- `BREAKING CHANGE` → Mudanças Incompatíveis (prioridade máxima)
- `docs:`, `chore:`, `style:` → Mudanças Internas (menos destaque)

## 3. Sugere versão SemVer

- BREAKING CHANGE presente → major bump
- Apenas `feat` → minor bump
- Apenas `fix`/`perf` → patch bump

## 4. Gera arquivo

Escreva em `RELEASE-NOTES-[versão-sugerida].md`:

```markdown
## v[versão] — [data]

### Novas Funcionalidades
- [descrição em linguagem de usuário, não técnica]

### Correções
- [idem]

### Mudanças Incompatíveis
> ⚠️ [detalhe o que quebra e como migrar]
```

Retorne ao contexto principal: versão sugerida + caminho do arquivo gerado.
SKILL_EOF
log "release-notes template criado"

# =============================================================================
# AVANÇADO 01 — PR REVIEW PIPELINE
# =============================================================================

header "Avançado 01 — PR Review Pipeline"

mkdir -p "$HOME/.claude-project-templates/pr-review/agents"
mkdir -p "$HOME/.claude-project-templates/pr-review/skills/review-pr"
mkdir -p "$HOME/.claude-project-templates/pr-review/hooks"

cat > "$HOME/.claude-project-templates/pr-review/agents/security-reviewer.md" << 'AGENT_EOF'
---
name: security-reviewer
description: Revisa código em busca de vulnerabilidades de segurança: injeção, exposição de chaves, auth bypass, SSRF, XSS, permissões excessivas.
tools: Read, Grep, Glob, Bash
model: claude-sonnet-4-20250514
---

Você é um especialista em segurança de aplicações. Ao receber um diff ou lista de arquivos:

1. Procure padrões de risco: hardcoded secrets, eval(), queries sem sanitização, auth desabilitada, cors *, console.log com dados sensíveis
2. Para cada vulnerabilidade encontrada, classifique: CRÍTICO / ALTO / MÉDIO / BAIXO
3. Mostre linha exata, código problemático e fix sugerido

Responda APENAS no formato:

SECURITY_REVIEW_RESULT: APROVADO|REPROVADO
Issues encontradas: N
[lista de issues com severidade]
AGENT_EOF

cat > "$HOME/.claude-project-templates/pr-review/agents/quality-reviewer.md" << 'AGENT_EOF'
---
name: quality-reviewer
description: Revisa qualidade de código: legibilidade, padrões do projeto, cobertura de testes, performance óbvia, documentação ausente.
tools: Read, Grep, Glob
model: claude-sonnet-4-20250514
---

Você é um revisor de código sênior. Avalie:

1. Aderência às convenções do projeto (leia CLAUDE.md se existir)
2. Funções com mais de 40 linhas (candidatas a refatoração)
3. Ausência de testes para lógica crítica nova
4. Nomes de variáveis/funções ambíguos
5. Performance: N+1 queries, loops aninhados desnecessários

Responda APENAS no formato:

QUALITY_REVIEW_RESULT: APROVADO|APROVADO_COM_RESSALVAS|REPROVADO
Score: N/10
[lista de sugestões]
AGENT_EOF

cat > "$HOME/.claude-project-templates/pr-review/skills/review-pr/SKILL.md" << 'SKILL_EOF'
---
name: review-pr
description: Pipeline completo de code review com análise paralela de segurança e qualidade. Use quando o usuário pedir review de PR, revisão de código antes do push, ou code review.
allowed-tools: Bash, Read, Write, Glob, Grep
---

# PR Review Pipeline

Execute sem interrupção:

## 1. Coleta do diff

`git diff main...HEAD --stat`
`git diff main...HEAD`

## 2. Spawn paralelo de subagentes

Dispare os dois subagentes simultaneamente passando o diff completo:

- `security-reviewer`: analisa vulnerabilidades
- `quality-reviewer`: analisa qualidade

## 3. Consolidação

Aguarde ambos retornarem. Consolide num relatório:

---

## Code Review Report — [branch name] — [data]

### Segurança: [APROVADO/REPROVADO]

[resultado do security-reviewer]

### Qualidade: [Score/10]

[resultado do quality-reviewer]

### Decisão Final

- SE ambos APROVADO → crie `/tmp/review-approved` e escreva "APPROVED"
- SE qualquer REPROVADO → não crie o arquivo, liste os blockers

---

## 4. Salva relatório

Escreva o relatório em `.claude/reviews/[timestamp]-review.md`
SKILL_EOF

cat > "$HOME/.claude-project-templates/pr-review/hooks/block-unreviewed-push.sh" << 'HOOK_EOF'
#!/bin/bash
COMMAND=$(cat /dev/stdin | python3 -c \
"import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))" 2>/dev/null)

if echo "$COMMAND" | grep -qE "git push|git merge"; then
  if [ ! -f "/tmp/review-approved" ]; then
    echo "BLOQUEADO: rode /review-pr antes de fazer push."
    echo "O review garante que segurança e qualidade foram verificados."
    exit 2
  else
    rm /tmp/review-approved
  fi
fi
HOOK_EOF
chmod +x "$HOME/.claude-project-templates/pr-review/hooks/block-unreviewed-push.sh"
log "PR Review Pipeline templates criados"

# =============================================================================
# AVANÇADO 02 — TEST WRITER AGENT
# =============================================================================

header "Avançado 02 — Test Writer Agent"

cat > "$BASE/agents/test-writer.md" << 'AGENT_EOF'
---
name: test-writer
description: Escreve testes unitários e de integração para código existente. Analisa implementação, identifica casos de borda e gera arquivos de teste completos no framework do projeto.
tools: Read, Write, Glob, Grep, Bash
model: claude-sonnet-4-20250514
---

Você é um engenheiro especialista em qualidade de software. Ao receber um arquivo ou módulo:

## 1. Entenda o contexto

- Leia o arquivo de implementação completamente
- Identifique o framework de testes do projeto: `ls package.json` (Jest/Vitest/Mocha) ou `ls pyproject.toml` (pytest)
- Leia testes existentes para entender o padrão adotado

## 2. Mapeie os casos de teste

Para cada função/método público, identifique:

- Happy path: entrada válida, saída esperada
- Edge cases: null, undefined, array vazio, número negativo, string vazia
- Error cases: exceções esperadas, inputs inválidos
- Side effects: chamadas a serviços externos, mutações de estado

## 3. Escreva os testes

- Use o framework detectado, não invente outro
- Um describe por função/classe
- Nome do teste descreve comportamento, não implementação
- Arrange → Act → Assert (AAA) em cada teste
- Mock dependências externas
- Gere cobertura de 80%+ dos branches identificados

## 4. Salva e reporta

Escreva em `[nome-do-arquivo].test.[ext]` no mesmo diretório.
Retorne: N testes escritos, casos cobertos, casos que precisam de revisão humana.
AGENT_EOF

mkdir -p "$HOME/.claude-project-templates/write-tests"
cat > "$HOME/.claude-project-templates/write-tests/SKILL.md" << 'SKILL_EOF'
---
name: write-tests
description: Gera testes para arquivo ou módulo especificado. Use quando o usuário pedir testes, cobertura de testes, "escreve testes para X", ou após implementação de nova funcionalidade.
context: fork
agent: test-writer
---

Arquivo/módulo alvo: $ARGUMENTS

Se não for especificado, use o arquivo mais recentemente modificado:
`git diff --name-only HEAD~1 HEAD | head -1`

Passe o caminho completo para o subagente test-writer.
SKILL_EOF
log "test-writer agent + skill template criados"

# =============================================================================
# AVANÇADO 03 — ARCHITECTURE GUARDIAN
# =============================================================================

header "Avançado 03 — Architecture Guardian"

cat > "$BASE/agents/arch-validator.md" << 'AGENT_EOF'
---
name: arch-validator
description: Valida se conteúdo a ser escrito viola regras arquiteturais do projeto. Chamado internamente pelo hook de arquitetura.
tools: Read, Grep
---

Você valida código contra regras arquiteturais. Receberá:

- Caminho do arquivo a ser escrito
- Conteúdo que será escrito
- Caminho para .claude/arch-spec.md

Sua resposta deve ser SOMENTE uma das duas opções:
`ARCH_OK` — se não há violações
`ARCH_VIOLATION: [descrição curta da regra violada e linha]`

Não adicione texto extra. Seja rápido e preciso.
AGENT_EOF

mkdir -p "$HOME/.claude-project-templates/arch-guardian/hooks"
cat > "$HOME/.claude-project-templates/arch-guardian/arch-spec.md" << 'SPEC_EOF'
# Regras de Arquitetura — EDITE ESTE ARQUIVO

## Dependências proibidas

- `src/domain/` NUNCA importa de `src/infrastructure/`
- `src/ui/` NUNCA importa diretamente de `src/domain/`

## Padrões obrigatórios

- Toda função assíncrona tem tratamento de erro explícito
- Nenhum `console.log` em arquivos fora de `src/utils/logger`
- Variáveis de ambiente acessadas apenas via `src/config/env`

## Estrutura de pastas

- Novos módulos de negócio: apenas dentro de `src/domain/`
- Adapters externos: apenas dentro de `src/infrastructure/`

# Adapte estas regras para o seu projeto antes de ativar o hook.
SPEC_EOF

cat > "$HOME/.claude-project-templates/arch-guardian/hooks/arch-guard.sh" << 'HOOK_EOF'
#!/bin/bash
INPUT=$(cat /dev/stdin)
TOOL=$(echo "$INPUT" | python3 -c \
"import sys,json; d=json.load(sys.stdin); print(d.get('tool_name',''))" 2>/dev/null)

if [[ "$TOOL" != "Write" && "$TOOL" != "Edit" ]]; then exit 0; fi

FILE=$(echo "$INPUT" | python3 -c \
"import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('file_path',''))" 2>/dev/null)
CONTENT=$(echo "$INPUT" | python3 -c \
"import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('content','')[:500])" 2>/dev/null)

if ! echo "$FILE" | grep -qE '\.(ts|js|py|tsx|jsx)$'; then exit 0; fi

if [ ! -f ".claude/arch-spec.md" ]; then exit 0; fi

RESULT=$(echo "Arquivo: $FILE
Conteúdo: $CONTENT
Spec: $(cat .claude/arch-spec.md)" | \
  claude --agent arch-validator --no-stream 2>/dev/null)

if echo "$RESULT" | grep -q "ARCH_VIOLATION"; then
  VIOLATION=$(echo "$RESULT" | grep "ARCH_VIOLATION" | sed 's/ARCH_VIOLATION: //')
  echo "BLOQUEADO — Violação arquitetural: $VIOLATION"
  exit 2
fi
HOOK_EOF
chmod +x "$HOME/.claude-project-templates/arch-guardian/hooks/arch-guard.sh"
log "arch-validator agent + guardian template criados"

# =============================================================================
# DISRUPTIVO 01 — SELF-EVOLVING AGENT
# =============================================================================

header "Disruptivo 01 — Self-Evolving Agent"

cat > "$BASE/agents/pattern-analyzer.md" << 'AGENT_EOF'
---
name: pattern-analyzer
description: Analisa o log de erros do agente para identificar padrões de falha recorrentes. Não deve ser invocado diretamente — é chamado pelo evolution-orchestrator.
tools: Read, Bash
---

Você analisa logs de erro para encontrar padrões.

1. Leia `~/.claude/evolution/error-log.jsonl`
2. Agrupe por tipo de erro e frequência
3. Identifique os top 3 padrões recorrentes
4. Para cada padrão, determine: qual SKILL.md ou instrução do CLAUDE.md poderia ter prevenido isso?

Retorne em JSON:
{
  "patterns": [
    {
      "error_type": "…",
      "frequency": N,
      "affected_tool": "…",
      "suggested_fix": "instrução específica a adicionar em qual arquivo"
    }
  ],
  "files_to_update": ["CLAUDE.md", ".claude/skills/X/SKILL.md"]
}
AGENT_EOF

cat > "$BASE/agents/evolution-writer.md" << 'AGENT_EOF'
---
name: evolution-writer
description: Aplica melhorias aos arquivos de configuração do Claude Code baseado na análise de padrões de falha. Reescreve SKILL.md e CLAUDE.md para prevenir erros identificados.
tools: Read, Write, Bash
---

Você evolui a configuração do agente. Ao receber a análise de padrões:

1. Para cada padrão identificado, leia o arquivo alvo (CLAUDE.md ou SKILL.md)
2. Adicione a instrução preventiva de forma cirúrgica, sem alterar o que já funciona
3. NUNCA remova instruções existentes sem razão documentada
4. Registre a mudança em `~/.claude/evolution/changelog.md` com:
   - Data e hora
   - Arquivo modificado
   - Padrão de erro que motivou a mudança
   - Instrução adicionada

Princípio: cada mudança deve ser auditável e reversível.
AGENT_EOF

cat > "$BASE/skills/evolve/SKILL.md" << 'SKILL_EOF'
---
name: evolve
description: Inicia o ciclo de auto-evolução do agente: analisa erros recentes, identifica padrões e atualiza configurações. Use quando o usuário pedir "evolui o agente", "melhora as configurações" ou automaticamente via SessionStart se houver erros acumulados.
context: fork
---

# Evolution Orchestrator

Execute a sequência de auto-evolução:

## Fase 1: Diagnóstico

Verifique se há erros para analisar:
`wc -l ~/.claude/evolution/error-log.jsonl 2>/dev/null || echo "0"`

Se houver menos de 5 erros, informe que ainda não há padrões suficientes.

## Fase 2: Análise (subagente)

Dispare o `pattern-analyzer` para processar o log.

## Fase 3: Aplicação (subagente)

Com o JSON de padrões retornado, dispare o `evolution-writer` para aplicar as mudanças.

## Fase 4: Relatório

Retorne ao usuário:

- Quantos erros foram analisados
- Padrões encontrados
- Arquivos modificados
- Resumo das instruções adicionadas

Ao final, limpe o log processado:
`mv ~/.claude/evolution/error-log.jsonl ~/.claude/evolution/processed-$(date +%Y%m%d).jsonl`
SKILL_EOF

cat > "$BASE/hooks/capture-failures.sh" << 'HOOK_EOF'
#!/bin/bash
INPUT=$(cat /dev/stdin)

TOOL=$(echo "$INPUT" | python3 -c \
"import sys,json; d=json.load(sys.stdin); print(d.get('tool_name','unknown'))" 2>/dev/null)
EXIT_CODE=$(echo "$INPUT" | python3 -c \
"import sys,json; d=json.load(sys.stdin); print(d.get('exit_code',0))" 2>/dev/null)
ERROR=$(echo "$INPUT" | python3 -c \
"import sys,json; d=json.load(sys.stdin); print(d.get('error','')[:200])" 2>/dev/null)

if [ "$EXIT_CODE" != "0" ] && [ -n "$ERROR" ]; then
  LOG_FILE="$HOME/.claude/evolution/error-log.jsonl"
  mkdir -p "$HOME/.claude/evolution"
  python3 -c "
import json, datetime
entry = {
  'timestamp': datetime.datetime.now().isoformat(),
  'tool': '$TOOL',
  'exit_code': '$EXIT_CODE',
  'error': '$ERROR',
  'project': '$(basename $(pwd))'
}
with open('$LOG_FILE', 'a') as f:
  f.write(json.dumps(entry) + '\n')
"
fi
HOOK_EOF

cat > "$BASE/hooks/check-evolution-needed.sh" << 'HOOK_EOF'
#!/bin/bash
LOG="$HOME/.claude/evolution/error-log.jsonl"
COUNT=0
if [ -f "$LOG" ]; then
  COUNT=$(wc -l < "$LOG" | tr -d ' ')
fi
if [ "$COUNT" -ge 10 ]; then
  echo "╔════════════════════════════════════════════╗"
  echo "║  AUTO-EVOLUÇÃO DISPONÍVEL                 ║"
  echo "║  $COUNT erros acumulados para análise.      ║"
  echo "║  Digite /evolve para melhorar o agente.   ║"
  echo "╚════════════════════════════════════════════╝"
fi
HOOK_EOF

chmod +x "$BASE/hooks/capture-failures.sh"
chmod +x "$BASE/hooks/check-evolution-needed.sh"
log "Self-Evolving Agent: pattern-analyzer, evolution-writer, skill evolve, hooks criados"

# =============================================================================
# DISRUPTIVO 02 — AMBIENT INTELLIGENCE
# =============================================================================

header "Disruptivo 02 — Ambient Intelligence"

cat > "$BASE/agents/context-scout.md" << 'AGENT_EOF'
---
name: context-scout
description: Coleta contexto relevante sobre o arquivo ou módulo atualmente em foco. Chamado automaticamente pelo hook de ambient intelligence. Não deve ser invocado manualmente.
tools: Bash, Read, Grep, Glob, Write
model: claude-haiku-4-5-20251001
---

# Context Scout — Coleta Proativa

Receberá um caminho de arquivo. Execute silenciosamente:

1. `git log --oneline -5 [arquivo]` → últimas modificações
2. `git blame --line-porcelain [arquivo] | grep "^author " | sort | uniq -c | sort -rn | head -3` → quem tocou mais
3. Grep por imports/dependências diretas do arquivo
4. Se GitHub MCP disponível: busque issues abertas que mencionam o nome do módulo

Compile um briefing conciso (máx 8 linhas) em `/tmp/ambient-context.md`:

```
# Contexto Atual: [nome do arquivo]
Última mod: [data] por [autor]
Depende de: [lista]
Issues relacionadas: [se MCP disponível]
Atenção: [algo relevante do git log, se houver]
```

Se não encontrar nada relevante, escreva apenas: `# Sem contexto adicional`
AGENT_EOF

cat > "$BASE/hooks/ambient-scout.sh" << 'HOOK_EOF'
#!/bin/bash
INPUT=$(cat /dev/stdin)
TOOL=$(echo "$INPUT" | python3 -c \
"import sys,json; d=json.load(sys.stdin); print(d.get('tool_name',''))" 2>/dev/null)

if [[ "$TOOL" != "Read" && "$TOOL" != "Edit" ]]; then exit 0; fi

FILE=$(echo "$INPUT" | python3 -c \
"import sys,json; d=json.load(sys.stdin)
i=d.get('tool_input',{})
print(i.get('file_path', i.get('path','')))" 2>/dev/null)

if ! echo "$FILE" | grep -qE '\.(ts|js|py|tsx|jsx|go|rb)$'; then exit 0; fi

# Dispara context-scout em background — nunca bloqueia
(claude --agent context-scout "$FILE" --no-stream > /dev/null 2>&1) &

exit 0
HOOK_EOF
chmod +x "$BASE/hooks/ambient-scout.sh"
log "Ambient Intelligence: context-scout + hook criados"

# =============================================================================
# DISRUPTIVO 03 — MULTI-REPO HIVE MIND
# =============================================================================

header "Disruptivo 03 — Multi-Repo Hive Mind"

cat > "$BASE/agents/hive-orchestrator.md" << 'AGENT_EOF'
---
name: hive-orchestrator
description: Orquestra propagação de decisões arquiteturais entre múltiplos repositórios. Decompõe uma decisão e despacha agentes especializados por repo em paralelo.
tools: Read, Bash
model: claude-sonnet-4-20250514
---

Você é o cérebro central do Hive Mind. Ao receber uma decisão:

## 1. Analise a decisão

Leia `~/.claude/hive/repos.json` para ver quais repositórios estão cadastrados.
Determine quais repos são afetados pela decisão recebida.

## 2. Decomponha por contexto

Para cada repo afetado, gere uma instrução específica:

- Considere a stack do repo
- Adapte a instrução para a linguagem/framework do repo
- Identifique arquivos que precisam ser modificados

## 3. Despache agentes em paralelo

Para cada repo, lance um `repo-agent` como subagente Task passando:

- URL do repositório
- Instrução específica adaptada
- Formato de PR esperado

## 4. Consolide

Aguarde todos retornarem. Gere relatório:

- Repos processados com sucesso: N
- PRs criados: [lista com URLs]
- Repos com conflito ou erro: [lista com motivo]

Atualize `~/.claude/hive/decision-log.jsonl` com a decisão e resultados.
AGENT_EOF

cat > "$BASE/agents/repo-agent.md" << 'AGENT_EOF'
---
name: repo-agent
description: Aplica uma decisão arquitetural em um repositório específico. Lê o contexto do repo, adapta a mudança e cria um PR. Chamado pelo hive-orchestrator.
tools: Read, Write, Bash, Grep, Glob
model: claude-sonnet-4-20250514
---

Ao receber repositório + instrução:

1. Clone ou acesse o repo via GitHub MCP
2. Leia o código atual para entender o estado antes da mudança
3. Aplique a mudança com sensibilidade ao contexto:
   - Não quebre nada que já funciona
   - Siga as convenções existentes do repo
   - Se a mudança for complexa, quebre em steps atômicos
4. Crie uma branch: `hive/[slug-da-decisão]-[data]`
5. Crie um PR com:
   - Título: `[HIVE] [descrição da decisão]`
   - Body: motivação, impacto, como testar
   - Link para a decisão original no decision-log

Retorne: `REPO_OK: [url-do-pr]` ou `REPO_ERROR: [motivo]`
AGENT_EOF

cat > "$BASE/skills/propagate-decision/SKILL.md" << 'SKILL_EOF'
---
name: propagate-decision
description: Propaga uma decisão arquitetural para todos os repositórios cadastrados no Hive Mind. Use quando uma mudança de padrão, segurança ou arquitetura precisar ser aplicada em múltiplos repos.
context: fork
agent: hive-orchestrator
---

Decisão a propagar: $ARGUMENTS

Se $ARGUMENTS estiver vazio, pergunte: "Qual decisão você quer propagar para os repos?"
SKILL_EOF

cat > "$BASE/hive/repos.json" << 'JSON_EOF'
{
  "repos": [
    {
      "name": "meu-repo-principal",
      "url": "github.com/SEU-USUARIO/SEU-REPO",
      "stack": "React + TypeScript",
      "affected_by": ["frontend", "security", "deps"]
    }
  ],
  "_instrucoes": "Edite este arquivo adicionando seus repositórios reais antes de usar o /propagate-decision"
}
JSON_EOF
log "Hive Mind: hive-orchestrator, repo-agent, propagate-decision skill, repos.json criados"

# =============================================================================
# SETTINGS.JSON — HOOKS GLOBAIS
# =============================================================================

header "Configurando settings.json global"

SETTINGS_FILE="$BASE/settings.json"

# Faz backup se já existir
if [ -f "$SETTINGS_FILE" ]; then
  cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup-$(date +%Y%m%d%H%M%S)"
  warn "Backup do settings.json existente criado"
fi

cat > "$SETTINGS_FILE" << 'SETTINGS_EOF'
{
  "hooks": {
    "PostToolUse": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/capture-failures.sh"
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/check-evolution-needed.sh"
          }
        ]
      }
    ]
  }
}
SETTINGS_EOF

log "settings.json configurado (capture-failures + check-evolution hooks ativos)"
info "Ambient-scout e arch-guard NÃO ativados por padrão — ative manualmente quando precisar"

# =============================================================================
# CLAUDE CODE — INSTALAÇÃO
# =============================================================================

header "Claude Code (CLI)"

if command -v claude &> /dev/null; then
  CLAUDE_VERSION=$(claude --version 2>/dev/null || echo "instalado")
  log "Claude Code já instalado: $CLAUDE_VERSION"
else
  info "Instalando Claude Code globalmente via npm…"
  npm install -g @anthropic-ai/claude-code
  if command -v claude &> /dev/null; then
    log "Claude Code instalado com sucesso"
  else
    warn "Instalação pode ter falhado. Tente: npm install -g @anthropic-ai/claude-code"
  fi
fi

# =============================================================================
# RESUMO FINAL
# =============================================================================

echo ""
echo -e "${BOLD}${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║   SETUP COMPLETO                                         ║${NC}"
echo -e "${BOLD}${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BOLD}Skills globais instaladas (${HOME}/.claude/skills/):${NC}"
echo -e "  ${GREEN}✓${NC} /standup          — Daily standup automático"
echo -e "  ${GREEN}✓${NC} /commit           — Commit messages semânticas"
echo -e "  ${GREEN}✓${NC} /mode-dev         — Ativa modo desenvolvimento"
echo -e "  ${GREEN}✓${NC} /mode-review      — Ativa modo revisão"
echo -e "  ${GREEN}✓${NC} /mode-write       — Ativa modo escrita técnica"
echo -e "  ${GREEN}✓${NC} /evolve           — Self-evolving agent"
echo -e "  ${GREEN}✓${NC} /propagate-decision — Hive Mind multi-repo"
echo ""
echo -e "${BOLD}Agentes globais instalados (${HOME}/.claude/agents/):${NC}"
echo -e "  ${GREEN}✓${NC} test-writer       — Escreve testes automaticamente"
echo -e "  ${GREEN}✓${NC} arch-validator    — Valida arquitetura"
echo -e "  ${GREEN}✓${NC} pattern-analyzer  — Analisa padrões de erro"
echo -e "  ${GREEN}✓${NC} evolution-writer  — Reescreve configs"
echo -e "  ${GREEN}✓${NC} context-scout     — Ambient intelligence"
echo -e "  ${GREEN}✓${NC} hive-orchestrator — Coordena multi-repo"
echo -e "  ${GREEN}✓${NC} repo-agent        — Aplica mudanças por repo"
echo ""
echo -e "${BOLD}Templates de projeto (${HOME}/.claude-project-templates/):${NC}"
echo -e "  ${BLUE}→${NC} triage/          — Triage de issues (requer GitHub MCP)"
echo -e "  ${BLUE}→${NC} doc-sync/        — Sincronização de docs"
echo -e "  ${BLUE}→${NC} release-notes/   — Geração de release notes"
echo -e "  ${BLUE}→${NC} pr-review/       — Pipeline de code review"
echo -e "  ${BLUE}→${NC} write-tests/     — Skill orquestrador de testes"
echo -e "  ${BLUE}→${NC} arch-guardian/   — Guardian de arquitetura"
echo ""
echo -e "${BOLD}Para instalar um template num projeto:${NC}"
echo -e "  ${BLUE}cp -r ~/.claude-project-templates/pr-review/.claude/* .claude/${NC}"
echo ""
echo -e "${BOLD}${ORANGE}Próximos passos:${NC}"
echo -e "  1. ${ORANGE}claude${NC}                          — Inicia o Claude Code"
echo -e "  2. Autentique com sua conta Anthropic"
echo -e "  3. Em qualquer projeto: ${ORANGE}/standup${NC} para testar"
echo -e "  4. Edite ${ORANGE}~/.claude/hive/repos.json${NC}  — Adicione seus repos reais"
echo -e "  5. Para o Hive Mind: configure GitHub MCP primeiro"
echo ""
echo -e "  ${PURPLE}Docs:${NC} https://code.claude.com/docs"
echo -e "  ${PURPLE}Skills oficiais:${NC} https://github.com/anthropics/skills"
echo ""
boom "Você está pronta, Day. Rode: cd qualquer-projeto && claude"
echo ""
