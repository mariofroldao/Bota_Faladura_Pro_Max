import Foundation

enum AIClient: String, CaseIterable, Identifiable {
    case chatGPT = "ChatGPT"
    case claude = "Claude"
    case gemini = "Gemini"
    case deepseek = "DeepSeek"
    case perplexity = "Perplexity"
    
    var id: String { self.rawValue }
    
    var url: URL {
        switch self {
        case .chatGPT: return URL(string: "https://chatgpt.com")!
        case .claude: return URL(string: "https://claude.ai")!
        case .gemini: return URL(string: "https://gemini.google.com")!
        case .deepseek: return URL(string: "https://chat.deepseek.com")!
        case .perplexity: return URL(string: "https://www.perplexity.ai")!
        }
    }
    
    // Seletores genéricos que funcionam na maioria ou específicos por plataforma
    var inputSelector: String {
        switch self {
        case .chatGPT: return "#prompt-textarea"
        case .claude: return "div[contenteditable='true']"
        case .gemini: return "div[role='textbox']"
        default: return "textarea, div[contenteditable='true']"
        }
    }
    
    var lastResponseSelector: String {
        switch self {
        case .chatGPT: return "div[data-testid^='conversation-turn-'] .markdown"
        case .claude: return ".claude-message .contents"
        case .gemini: return ".message-content"
        default: return "article, .message, .answer"
        }
    }
}

class DebateManager: ObservableObject {
    @Published var theme: String = ""
    @Published var contextFromFile: String = ""
    @Published var totalRounds: Int = 3
    @Published var currentRound: Int = 0
    @Published var highlights: [RoundHighlight] = []
    @Published var isRunning: Bool = false
    
    @Published var agent1Role: AgentRole = .optimist
    @Published var agent2Role: AgentRole = .skeptic
    
    @Published var agent1Client: AIClient = .chatGPT
    @Published var agent2Client: AIClient = .claude
    
    func swapRoles() {
        let temp = agent1Role
        agent1Role = agent2Role
        agent2Role = temp
    }
    
    func getFullPrompt(for role: AgentRole, topic: String) -> String {
        let basePrompt = getSystemPrompt(for: role, topic: topic)
        let context = contextFromFile.isEmpty ? "" : "\n\nContexto Adicional (Ficheiro):\n\(contextFromFile)"
        return "\(basePrompt)\(context)\n\nIMPORTANTE: Usa pensamento profundo. Começa o debate agora."
    }
    
    private func getSystemPrompt(for role: AgentRole, topic: String) -> String {
        switch role {
        case .optimist:
            return "Persona: 'O Otimista'. Foca-te no progresso e benefícios de '\(topic)'. Sê positivo e inovador."
        case .skeptic:
            return "Persona: 'Velho do Restelo'. Sê cético e pessimista sobre '\(topic)'. Foca-te nos riscos e no passado."
        }
    }
}
