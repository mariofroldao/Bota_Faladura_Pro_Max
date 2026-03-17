import SwiftUI
import WebKit

struct MainView: View {
    @StateObject var manager = DebateManager()
    
    var body: some View {
        VStack(spacing: 0) {
            // Painel de Controlo Superior
            ControlPanelView(manager: manager)
                .frame(height: 120)
                .background(Color(NSColor.windowBackgroundColor))
            
            Divider()
            
            // Zona de Debate (Split View)
            HStack(spacing: 0) {
                // IA 1
                VStack(spacing: 0) {
                    LabelBanner(role: manager.agent1Role)
                    WebViewWrapper(url: URL(string: "https://chatgpt.com")!)
                }
                
                Divider()
                
                // IA 2
                VStack(spacing: 0) {
                    LabelBanner(role: manager.agent2Role)
                    WebViewWrapper(url: URL(string: "https://claude.ai")!)
                }
            }
        }
        .frame(minWidth: 1000, minHeight: 700)
    }
}

struct LabelBanner: View {
    let role: AgentRole
    
    var body: some View {
        HStack {
            Spacer()
            Text(role.rawValue.uppercased())
                .font(.headline)
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.vertical, 8)
        .background(role == .optimist ? Color.green.opacity(0.8) : Color.red.opacity(0.8))
    }
}

struct ControlPanelView: View {
    @ObservedObject var manager: DebateManager
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            VStack(alignment: .leading) {
                Text("Tema do Debate").font(.caption).bold()
                TextField("Ex: O impacto da IA no emprego...", text: $manager.theme)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .frame(width: 300)
            
            VStack {
                Text("Rondas").font(.caption).bold()
                Stepper("\(manager.totalRounds)", value: $manager.totalRounds, in: 1...10)
            }
            
            Button(action: {
                manager.swapRoles()
            }) {
                VStack {
                    Image(systemName: "arrow.left.and.right.righttriangle.left.and.righttriangle.right")
                    Text("Inverter Papéis").font(.caption2)
                }
            }
            .buttonStyle(.bordered)
            
            Button(action: {
                // Iniciar Debate
            }) {
                Text("Iniciar Debate")
                    .bold()
                    .frame(width: 120, height: 40)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            
            Spacer()
            
            Button(action: {
                // Ver Histórico / PDF
            }) {
                Image(systemName: "doc.text.magnifyingglass")
                Text("Relatórios")
            }
        }
        .padding()
    }
}

struct WebViewWrapper: NSViewRepresentable {
    let url: URL
    
    func makeNSView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.customUserAgent = StealthService.userAgent
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {}
}
