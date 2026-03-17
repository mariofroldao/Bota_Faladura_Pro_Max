import SwiftUI
import WebKit
import AppKit

// 1. Subclasse para garantir o foco de teclado e eventos de rato
class ClickableWebView: WKWebView {
    override var acceptsFirstResponder: Bool { true }
    
    override func mouseDown(with event: NSEvent) {
        // Forçar a app e a janela a tornarem-se ativas ao clicar na WebView
        NSApp.activate(ignoringOtherApps: true)
        self.window?.makeKeyAndOrderFront(nil)
        self.window?.makeFirstResponder(self)
        super.mouseDown(with: event)
    }
}

// 2. Pool de processos partilhado para consistência de sessão
class WebViewProcessPool {
    static let shared = WKProcessPool()
}

public struct MainView: View {
    @StateObject var manager = DebateManager()
    
    public init() {}
    
    public var body: some View {
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
        .onAppear {
            // Garantir que a App toma o foco ao abrir
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}

// 3. Wrapper melhorado com injeção de hardware real e correção de foco
struct WebViewWrapper: NSViewRepresentable {
    let url: URL
    
    func makeNSView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.processPool = WebViewProcessPool.shared
        config.websiteDataStore = .default()
        
        // Ativar funcionalidades de developer para ajudar na depuração se necessário
        config.preferences.setValue(true, forKey: "developerExtrasEnabled")
        
        let webView = ClickableWebView(frame: .zero, configuration: config)
        
        // User-Agent de um Safari real em macOS Sonoma (mais fidedigno para WKWebView)
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15"
        
        // Script avançado de Stealth: Emula hardware e remove marcas de automação
        let stealthScriptContent = """
        // 1. Remover flag de automação
        Object.defineProperty(navigator, 'webdriver', { get: () => false });
        
        // 2. Emular propriedades de hardware reais
        Object.defineProperty(navigator, 'deviceMemory', { get: () => 8 });
        Object.defineProperty(navigator, 'hardwareConcurrency', { get: () => 8 });
        
        // 3. Mock de plugins para parecer um browser real
        Object.defineProperty(navigator, 'plugins', { get: () => [1, 2, 3, 4, 5] });
        
        // 4. Corrigir permissões (sites de IA verificam isto)
        const originalQuery = navigator.permissions.query;
        navigator.permissions.query = (parameters) => (
            parameters.name === 'notifications' ?
            Promise.resolve({ state: Notification.permission }) :
            originalQuery(parameters)
        );

        // 5. Garantir que cliques são processados como 'Trusted'
        window.addEventListener('mousedown', () => {
            window.focus();
        }, true);
        """
        
        let stealthScript = WKUserScript(source: stealthScriptContent, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        config.userContentController.addUserScript(stealthScript)
        
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        if let currentURL = nsView.url, currentURL.host != url.host {
            nsView.load(URLRequest(url: url))
        }
    }
}
...
