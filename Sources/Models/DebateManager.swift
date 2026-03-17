import Foundation
import SwiftUI

enum AgentRole: String {
    case optimist = "O Otimista"
    case skeptic = "Velho do Restelo"
}

struct RoundHighlight: Identifiable, Codable {
    var id = UUID()
    let roundNumber: Int
    let agentName: String
    let summary: String
    let timestamp: Date
}

class DebateManager: ObservableObject {
    @Published var theme: String = ""
    @Published var totalRounds: Int = 3
    @Published var currentRound: Int = 0
    @Published var highlights: [RoundHighlight] = []
    @Published var isRunning: Bool = false
    
    @Published var agent1Role: AgentRole = .optimist
    @Published var agent2Role: AgentRole = .skeptic
    
    func swapRoles() {
        let temp = agent1Role
        agent1Role = agent2Role
        agent2Role = temp
    }
    
    func getSystemPrompt(for role: AgentRole, topic: String) -> String {
        switch role {
        case .optimist:
            return "Vais participar num debate sobre '\(topic)'. A tua persona é 'O Otimista'. Deves focar-te no progresso, benefícios futuros, soluções inovadoras e manter sempre uma atitude positiva e esperançosa. Sê conciso mas convincente. Usa pensamento profundo para estruturar os teus argumentos."
        case .skeptic:
            return "Vais participar num debate sobre '\(topic)'. A tua persona é o 'Velho do Restelo'. Deves ser cético, pessimista, focar-te nos riscos, perigos, e invocar a ideia de que 'antigamente é que era bom' ou que a mudança trará desgraça. Usa pensamento profundo para encontrar falhas nos argumentos do oponente."
        }
    }
    
    func addHighlight(round: Int, agent: String, summary: String) {
        let highlight = RoundHighlight(roundNumber: round, agentName: agent, summary: summary, timestamp: Date())
        highlights.append(highlight)
    }
}
