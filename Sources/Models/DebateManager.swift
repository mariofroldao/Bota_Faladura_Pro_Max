import Foundation
import SwiftUI

public class DebateManager: ObservableObject {
    @Published public var theme: String = ""
    @Published public var contextFromFile: String = ""
    @Published public var totalRounds: Int = 3
    @Published public var currentRound: Int = 0
    @Published public var highlights: [RoundHighlight] = []
    @Published public var isRunning: Bool = false
    
    @Published public var agent1Role: AgentRole = .optimist
    @Published public var agent2Role: AgentRole = .skeptic
    
    @Published public var agent1Client: AIClient = .chatGPT
    @Published public var agent2Client: AIClient = .claude
    
    public init() {}
    
    public func swapRoles() {
        let temp = agent1Role
        agent1Role = agent2Role
        agent2Role = temp
    }
    
    public func getFullPrompt(for role: AgentRole, topic: String) -> String {
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
