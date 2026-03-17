import SwiftUI
import WebKit

struct MainView: View {
    @StateObject var manager = DebateManager()
    
    var body: some View {
        VStack(spacing: 0) {
            ControlPanelView(manager: manager)
                .frame(height: 140)
                .background(Color(NSColor.windowBackgroundColor))
            
            Divider()
            
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    ClientHeader(role: manager.agent1Role, client: $manager.agent1Client)
                    WebViewWrapper(url: manager.agent1Client.url)
                }
                
                Divider()
                
                VStack(spacing: 0) {
                    ClientHeader(role: manager.agent2Role, client: $manager.agent2Client)
                    WebViewWrapper(url: manager.agent2Client.url)
                }
            }
        }
        .frame(minWidth: 1100, minHeight: 800)
    }
}

struct ClientHeader: View {
    let role: AgentRole
    @Binding var client: AIClient
    
    var body: some View {
        VStack(spacing: 4) {
            Text(role.rawValue.uppercased())
                .font(.caption.bold())
                .foregroundColor(.white)
            
            Picker("", selection: $client) {
                ForEach(AIClient.allCases) { client in
                    Text(client.rawValue).tag(client)
                }
            }
            .pickerStyle(.menu)
            .frame(width: 150)
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(role == .optimist ? Color.green.opacity(0.8) : Color.red.opacity(0.8))
    }
}

struct ControlPanelView: View {
    @ObservedObject var manager: DebateManager
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "pencil.and.outline")
                    Text("Configuração do Debate").font(.headline)
                }
                
                TextField("Tema do Debate (ex: Futuro de Marte)", text: $manager.theme)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                HStack {
                    Button(action: {
                        FileService.pickFile { url in
                            if let url = url, let text = FileService.extractText(from: url) {
                                manager.contextFromFile = text
                            }
                        }
                    }) {
                        Label(manager.contextFromFile.isEmpty ? "Anexar Ficheiro" : "Ficheiro Anexado ✅", systemImage: "paperclip")
                    }
                    .buttonStyle(.bordered)
                    
                    if !manager.contextFromFile.isEmpty {
                        Button(action: { manager.contextFromFile = "" }) {
                            Image(systemName: "trash")
                        }
                        .buttonStyle(.plain)
                        .foregroundColor(.red)
                    }
                    
                    Spacer()
                    
                    Text("Rondas:")
                    Stepper("\(manager.totalRounds)", value: $manager.totalRounds, in: 1...10)
                }
            }
            .frame(width: 450)
            
            Divider().frame(height: 80)
            
            VStack(spacing: 15) {
                Button(action: { manager.swapRoles() }) {
                    Label("Inverter Papéis", systemImage: "arrow.left.and.right")
                        .frame(width: 150)
                }
                .buttonStyle(.bordered)
                
                Button(action: { /* Iniciar */ }) {
                    Text("INICIAR DEBATE")
                        .bold()
                        .frame(width: 150, height: 40)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            
            Spacer()
            
            VStack {
                Button(action: { /* PDF */ }) {
                    VStack {
                        Image(systemName: "doc.richtext").font(.title)
                        Text("Relatórios")
                    }
                }
                .buttonStyle(.plain)
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
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        if nsView.url?.host != url.host {
            nsView.load(URLRequest(url: url))
        }
    }
}
