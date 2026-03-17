# AGENTS.md — Regras de Colaboração (Bota_Faladura_Pro_Max)

Este documento define os protocolos de desenvolvimento para a aplicação "Bota_Faladura_Pro_Max" (Moderador de Debate entre IAs).

## 1) Core: Protocolo "Stealth" (Anti-Detection)
Para evitar que as plataformas de IA (OpenAI, Anthropic, etc.) bloqueiem o uso via WKWebView:
- **User-Agent:** Usar sempre strings de navegadores reais e atualizados.
- **Interação Humana Simulada:** Não injetar texto de uma só vez via `.value = ...`. Usar `evaluateJavaScript` para simular eventos de teclado (`keydown`, `keypress`, `input`, `keyup`) com delays aleatórios (50ms - 200ms) entre caracteres.
- **Randomização:** Introduzir variações aleatórias no tempo de espera entre rondas e na detecção de botões de envio.
- **Fingerprinting:** Limpar cookies e cache periodicamente se houver bloqueios persistentes.

## 2) Estrutura do Debate
- **IA1 (O Otimista):** Sempre focado em benefícios, progresso e visão positiva.
- **IA2 (Velho do Restelo):** Sempre cético, pessimista e focado em riscos ou "no meu tempo era melhor".
- **Moderador (Swift):** 
    - Extrai o texto limpo (removendo "Olá", "Concordo", etc).
    - Injeta o texto na outra IA com o prefixo: "O teu oponente disse: [TEXTO]. Refuta/Responde mantendo a tua persona."
    - Gera resumos parciais (highlights) após cada ronda.

## 3) Gestão de Relatórios (PDF)
- **Formatação:** Usar `PDFKit`. O relatório deve conter:
    - Capa com Tema e Data.
    - Tabela de Resumo de Rondas (Highlights).
    - Secção de Conclusões (editável pelo utilizador ou gerada pelas IAs).
- **Histórico:** Salvar todos os PDFs na pasta `reports/history/`.
- **Download:** Permitir exportar o PDF para qualquer local do sistema.

## 4) Fluxo Git & GitHub (Alinhado com Nexo_IA)
- **Commits Atómicos:** Realizar commits após cada funcionalidade (ex: UI base, Lógica de Rounds, PDF Generator).
- **Push Obrigatório:** Subir para o GitHub logo após a criação do repositório e após cada etapa validada.
- **Issues:** Criar e gerir issues para cada funcionalidade ou bug reportado.

## 5) Ordem de Execução
1. Configuração do Repositório Remoto.
2. Esqueleto da App macOS (SwiftUI/AppKit).
3. Implementação das WKWebViews com Stealth.
4. Lógica de Debate e Gestão de Rondas.
5. Sistema de Geração de Relatórios PDF.
6. Validação final e submissão.

---
**Status de Evolução:**
- Estrutura de Pastas: 0 -> 1
- AGENTS.md: 0 -> 1
- Repositório Git: 0 -> 1
