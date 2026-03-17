import Foundation

public enum AgentRole: String, Codable {
    case optimist = "O Otimista"
    case skeptic = "Velho do Restelo"
}

public struct RoundHighlight: Identifiable, Codable {
    public var id = UUID()
    public let roundNumber: Int
    public let agentName: String
    public let summary: String
    public let timestamp: Date
}

public enum AIClient: String, CaseIterable, Identifiable, Codable {
    case chatGPT = "ChatGPT"
    case claude = "Claude"
    case gemini = "Gemini"
    case deepseek = "DeepSeek"
    case perplexity = "Perplexity"
    
    public var id: String { self.rawValue }
    
    public var url: URL {
        switch self {
        case .chatGPT: return URL(string: "https://chatgpt.com")!
        case .claude: return URL(string: "https://claude.ai")!
        case .gemini: return URL(string: "https://gemini.google.com")!
        case .deepseek: return URL(string: "https://chat.deepseek.com")!
        case .perplexity: return URL(string: "https://www.perplexity.ai")!
        }
    }
    
    public var inputSelector: String {
        switch self {
        case .chatGPT: return "#prompt-textarea"
        case .claude: return "div[contenteditable='true']"
        case .gemini: return "div[role='textbox']"
        default: return "textarea, div[contenteditable='true']"
        }
    }
    
    public var lastResponseSelector: String {
        switch self {
        case .chatGPT: return "div[data-testid^='conversation-turn-'] .markdown"
        case .claude: return ".claude-message .contents"
        case .gemini: return ".message-content"
        default: return "article, .message, .answer"
        }
    }
}
