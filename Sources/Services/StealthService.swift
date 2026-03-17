import Foundation

struct StealthService {
    static let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    
    static func generateInjectionScript(text: String) -> String {
        let escapedText = text.replacingOccurrences(of: "'", with: "\\'")
            .replacingOccurrences(of: "\n", with: "\\n")
        
        return """
        (async () => {
            const inputField = document.querySelector('div[contenteditable="true"], textarea, #prompt-textarea');
            if (!inputField) return;
            
            inputField.focus();
            const textToType = '\(escapedText)';
            
            for (let char of textToType) {
                const event = new KeyboardEvent('keydown', { key: char, bubbles: true });
                inputField.dispatchEvent(event);
                
                // Simulação simples de inserção de caractere
                if (inputField.tagName === 'TEXTAREA' || inputField.tagName === 'INPUT') {
                    inputField.value += char;
                } else {
                    document.execCommand('insertText', false, char);
                }
                
                const inputEvent = new Event('input', { bubbles: true });
                inputField.dispatchEvent(inputEvent);
                
                const keyupEvent = new KeyboardEvent('keyup', { key: char, bubbles: true });
                inputField.dispatchEvent(keyupEvent);
                
                // Delay aleatório entre 20ms e 80ms para parecer humano
                await new Promise(r => setTimeout(r, Math.random() * 60 + 20));
            }
            
            // Tentar encontrar o botão de enviar e clicar
            setTimeout(() => {
                const sendButton = document.querySelector('button[data-testid="send-button"], button.send-button, button:has(svg)');
                if (sendButton && !sendButton.disabled) {
                    sendButton.click();
                } else {
                    // Fallback: pressionar Enter
                    const enterEvent = new KeyboardEvent('keydown', { key: 'Enter', code: 'Enter', keyCode: 13, which: 13, bubbles: true });
                    inputField.dispatchEvent(enterEvent);
                }
            }, 500);
        })();
        """
    }
}
