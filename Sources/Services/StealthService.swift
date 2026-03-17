import Foundation

struct StealthService {
    static let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    
    static func generateInjectionScript(text: String, selector: String) -> String {
        let escapedText = text.replacingOccurrences(of: "'", with: "\\'")
            .replacingOccurrences(of: "\n", with: "\\n")
        
        return """
        (async () => {
            const selector = '\(selector)';
            const inputField = document.querySelector(selector) || document.querySelector('div[contenteditable="true"], textarea');
            if (!inputField) {
                console.error("Campo de input não encontrado com o seletor: " + selector);
                return;
            }
            
            inputField.focus();
            const textToType = '\(escapedText)';
            
            for (let char of textToType) {
                const event = new KeyboardEvent('keydown', { key: char, bubbles: true });
                inputField.dispatchEvent(event);
                
                if (inputField.tagName === 'TEXTAREA' || inputField.tagName === 'INPUT') {
                    inputField.value += char;
                } else {
                    document.execCommand('insertText', false, char);
                }
                
                const inputEvent = new Event('input', { bubbles: true });
                inputField.dispatchEvent(inputEvent);
                
                const keyupEvent = new KeyboardEvent('keyup', { key: char, bubbles: true });
                inputField.dispatchEvent(keyupEvent);
                
                await new Promise(r => setTimeout(r, Math.random() * 40 + 10));
            }
            
            setTimeout(() => {
                const sendButton = document.querySelector('button[data-testid="send-button"], button.send-button, button:has(svg)');
                if (sendButton && !sendButton.disabled) {
                    sendButton.click();
                } else {
                    const enterEvent = new KeyboardEvent('keydown', { key: 'Enter', code: 'Enter', keyCode: 13, which: 13, bubbles: true });
                    inputField.dispatchEvent(enterEvent);
                }
            }, 500);
        })();
        """
    }
    
    static func generateExtractionScript(selector: String) -> String {
        return """
        (() => {
            const elements = document.querySelectorAll('\(selector)');
            if (elements.length > 0) {
                return elements[elements.length - 1].innerText;
            }
            return "";
        })();
        """
    }
}
