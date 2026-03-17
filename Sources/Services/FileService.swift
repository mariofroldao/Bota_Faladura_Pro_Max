import Foundation
import PDFKit
import AppKit

struct FileService {
    static func extractText(from url: URL) -> String? {
        let extensionStr = url.pathExtension.lowercased()
        
        if extensionStr == "pdf" {
            return extractTextFromPDF(url: url)
        } else if extensionStr == "txt" || extensionStr == "md" {
            return try? String(contentsOf: url, encoding: .utf8)
        }
        return nil
    }
    
    private static func extractTextFromPDF(url: URL) -> String? {
        guard let pdf = PDFDocument(url: url) else { return nil }
        var fullText = ""
        for i in 0..<pdf.pageCount {
            if let page = pdf.page(at: i), let content = page.string {
                fullText += content + "\n"
            }
        }
        return fullText
    }
    
    static func pickFile(completion: @escaping (URL?) -> Void) {
        let openPanel = NSOpenPanel()
        openPanel.allowedContentTypes = [.pdf, .plainText]
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        
        openPanel.begin { result in
            if result == .OK {
                completion(openPanel.url)
            } else {
                completion(nil)
            }
        }
    }
}
