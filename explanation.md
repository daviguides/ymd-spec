# YMD/PMD Format - Explicação Detalhada

## O que é YMD/PMD?

**YMD/PMD** é um **formato estruturado para criação de prompts de IA** que resolve o problema fundamental de **prompts monolíticos, difíceis de manter e impossíveis de reutilizar**.

Em vez de criar prompts gigantes e duplicados, YMD/PMD permite **composição modular** através de dois tipos de arquivo complementares:

---

## **YMD (YAML + Markdown + Jinja2)**

### Propósito
Arquivos **orquestradores** que agregam componentes reutilizáveis em prompts completos.

### Características
- **Contém metadados** (`meta:` section) com id, versão, tipo
- **Define estrutura** do prompt com seções customizáveis
- **Orquestra componentes** através de `{% include %}`
- **Gerencia variáveis** que fluem para componentes incluídos
- **É o ponto de entrada** - o arquivo que você "executa"

### Exemplo Conceitual
```yaml
meta:
  id: code_reviewer
  kind: review
  version: 1.0.0
  title: Code Review Assistant

system: |
  {% include "roles/senior_dev.pmd" %}

review_focus: |
  {% include "checklists/quality.pmd" %}
  {% include "checklists/security.pmd" %}

user: |
  Review this {{ language }} code: {{ code }}
```

**Analogia**: YMD é como um **roteiro de filme** - define a estrutura geral, os "atores" (PMDs), e como tudo se conecta.

---

## **PMD (Prompt Markdown + Jinja2)**

### Propósito
Arquivos **componentes** que são blocos reutilizáveis de conteúdo, sem metadados.

### Características
- **NÃO tem seção `meta:`** (essa é a diferença chave!)
- **Puro Markdown + Jinja2** - conteúdo e lógica de template
- **Reutilizável** - pode ser incluído em múltiplos YMDs
- **Pode incluir outros PMDs** - composição recursiva
- **Define um conceito** - role, checklist, formato, princípio

### Exemplo Conceitual
```markdown
{# Senior Developer Role
   Expected variables:
   - language: Programming language
   - experience_level: Years of experience
#}

You are a **senior {{ language }} developer** with {{ experience_level }} years of experience.

Your approach:
- Provide clear, actionable feedback
- Focus on best practices and maintainability
- Consider performance and security implications
```

**Analogia**: PMD é como **peças de LEGO** - blocos modulares que você combina de diferentes formas para criar estruturas complexas.

---

## Por que isso importa?

### **Problema: Prompts Monolíticos**
```yaml
# ❌ ANTES - Monolítico e difícil de manter
system: |
  You are a senior Python developer with 10+ years of experience.
  You focus on clean code, SOLID principles, and test coverage.
  You always check for security vulnerabilities.
  You prefer async/await over threading.
  [... 150+ linhas misturando role, princípios, checklist ...]

user: |
  Review this code: {{ code }}
```

**Problemas**:
- ❌ **Duplicação**: Mesmo conteúdo copiado em múltiplos prompts
- ❌ **Manutenção**: Mudança em "senior developer role" requer editar 20 arquivos
- ❌ **Inconsistência**: Versões ligeiramente diferentes do mesmo conceito
- ❌ **Difícil de testar**: Não dá pra testar "role" isoladamente
- ❌ **Sem versionamento**: Não dá pra rastrear mudanças em partes específicas

### **Solução: Composição Modular**
```yaml
# ✅ DEPOIS - Modular e reutilizável
meta:
  id: python_code_reviewer
  kind: review
  version: 1.0.0
  title: Python Code Review Assistant

system: |
  {% include "roles/senior_python_dev.pmd" %}
  {% include "principles/clean_code.pmd" %}
  {% include "principles/async_first.pmd" %}

review_focus: |
  {% include "checklists/security.pmd" %}
  {% include "checklists/testing.pmd" %}

user: |
  Review this code: {{ code }}
```

**Benefícios**:
- ✅ **DRY**: `senior_python_dev.pmd` definido uma vez, usado em múltiplos prompts
- ✅ **Manutenibilidade**: Mudança em role → edita 1 arquivo, afeta todos os usos
- ✅ **Consistência**: "Senior Python Dev" sempre significa a mesma coisa
- ✅ **Testável**: Cada PMD pode ser testado isoladamente
- ✅ **Versionado**: Cada componente tem sua própria versão e changelog

---

## Conceitos-Chave

### **1. Separação de Responsabilidades**

**YMD** = Estrutura + Orquestração
- Define **o que** o prompt faz (metadata)
- Organiza **como** componentes se conectam (sections)
- Gerencia **variáveis** e **contexto**

**PMD** = Conteúdo Reutilizável
- Define **um conceito** específico (role, checklist, format)
- Pode ser **composto** de outros PMDs
- **Sem overhead** de metadata

### **2. Composição Recursiva**

PMDs podem incluir outros PMDs, permitindo hierarquias:

```
main.ymd
  ├─ roles/senior_dev.pmd
  │   ├─ roles/base_developer.pmd
  │   └─ principles/solid.pmd
  │
  └─ checklists/quality.pmd
      ├─ checklists/code_style.pmd
      └─ checklists/performance.pmd
```

### **3. Variáveis Flow Down**

Variáveis definidas no YMD (ou passadas em runtime) fluem para todos os PMDs incluídos:

```yaml
# main.ymd
{% set language = "Python" %}
{% set experience = 10 %}
{% include "roles/senior_dev.pmd" %}

# roles/senior_dev.pmd
You are a senior {{ language }} developer with {{ experience }} years.
  └─ includes: principles/best_practices.pmd

# principles/best_practices.pmd
For {{ language }}, always follow:
- PEP 8 style guide
```

### **4. Seções Customizáveis**

YMD **não limita** você a `system`, `user`, etc. Você pode criar qualquer seção que faça sentido:

```yaml
meta:
  id: api_designer
  kind: api_design
  version: 1.0.0

system: |
  {% include "roles/api_architect.pmd" %}

api_principles: |
  {% include "principles/rest.pmd" %}

security_requirements: |
  {% include "security/api_security.pmd" %}

validation_rules: |
  {% include "validation/api_validation.pmd" %}

user: |
  Design API for: {{ requirement }}
```

---

## Casos de Uso Reais

### **1. Code Review Assistant**
```
code_review.ymd
  ├─ roles/senior_developer.pmd
  ├─ checklists/quality.pmd
  ├─ checklists/security.pmd
  └─ formats/review_comment.pmd
```

### **2. API Design Assistant**
```
api_design.ymd
  ├─ roles/api_architect.pmd
  ├─ principles/rest_principles.pmd
  ├─ security/api_security.pmd
  └─ formats/openapi_spec.pmd
```

### **3. Documentation Generator**
```
docs_generator.ymd
  ├─ roles/technical_writer.pmd
  ├─ styles/documentation_style.pmd
  ├─ formats/markdown_format.pmd
  └─ examples/code_examples.pmd
```

---

## Filosofia de Design

### **Single Source of Truth**
Cada conceito (role, princípio, checklist) é definido **uma vez** em um PMD e reutilizado onde necessário.

### **Composição sobre Herança**
Em vez de criar hierarquias complexas, você **compõe** comportamento incluindo múltiplos PMDs.

### **Explícito sobre Implícito**
Estrutura é clara - você vê exatamente quais componentes estão sendo usados através dos `{% include %}`.

### **Modularidade Extrema**
Componentes são **pequenos e focados** - cada PMD tem uma responsabilidade única.

---

## Como Funciona na Prática

### **1. Definir Componentes (PMDs)**
```bash
components/
├── roles/
│   ├── senior_dev.pmd
│   ├── api_architect.pmd
│   └── tech_writer.pmd
│
├── checklists/
│   ├── security.pmd
│   ├── performance.pmd
│   └── testing.pmd
│
└── principles/
    ├── solid.pmd
    ├── rest.pmd
    └── clean_code.pmd
```

### **2. Compor Prompts (YMDs)**
```bash
prompts/
├── code_review.ymd      # uses: senior_dev, security, testing
├── api_design.ymd       # uses: api_architect, rest, security
└── docs_generator.ymd   # uses: tech_writer, clean_code
```

### **3. Renderizar com Variáveis**
```python
from ymd_prompt import render_ymd

result = render_ymd(
    "prompts/code_review.ymd",
    variables={
        "language": "Python",
        "code": user_code,
        "strict_mode": True
    }
)
# result = prompt completo pronto para enviar à LLM
```

---

## Resumo: Por Que YMD/PMD?

| Aspecto | Prompts Tradicionais | YMD/PMD |
|---------|---------------------|---------|
| **Reutilização** | Copia/cola manual | Composição via includes |
| **Manutenção** | Editar múltiplos arquivos | Editar um componente |
| **Consistência** | Versões divergentes | Single source of truth |
| **Organização** | Monolítico | Modular por conceito |
| **Testabilidade** | Difícil isolar partes | Componentes testáveis |
| **Versionamento** | Tudo ou nada | Granular por componente |
| **Complexidade** | Cresce linearmente | Escalável por composição |

---

**Em uma frase**: YMD/PMD transforma prompts de IA de **blocos monolíticos** em **sistemas modulares e componíveis**, trazendo as melhores práticas de engenharia de software para prompt engineering.
