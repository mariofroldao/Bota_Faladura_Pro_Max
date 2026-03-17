import Foundation
import PDFKit
import SwiftUI

class PDFGenerator {
    static func generateReport(highlights: [RoundHighlight], theme: String, conclusions: String) -> Data? {
        let pdfMetaData = [
            kPDFDocumentAttributeTitleKey: "Relatório de Debate: \(theme)",
            kPDFDocumentAttributeAuthorKey: "Bota_Faladura_Pro_Max"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        // No macOS, o PDFRenderer é diferente do iOS. 
        // Vou usar o approach de Core Graphics para compatibilidade macOS.
        
        let pdfData = NSMutableData()
        guard let dataConsumer = CGDataConsumer(data: pdfData as CFMutableData) else { return nil }
        
        var mediaBox = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4
        guard let pdfContext = CGContext(consumer: dataConsumer, mediaBox: &mediaBox, nil) else { return nil }
        
        pdfContext.beginPage(nil)
        
        // Desenhar Capa
        drawTitle(theme: theme, context: pdfContext, rect: mediaBox)
        
        // Desenhar Tabela de Rondas
        var currentY: CGFloat = 700
        for highlight in highlights {
            currentY = drawHighlight(highlight: highlight, context: pdfContext, startY: currentY, rect: mediaBox)
            if currentY < 100 {
                pdfContext.endPage()
                pdfContext.beginPage(nil)
                currentY = 800
            }
        }
        
        // Página de Conclusões
        pdfContext.endPage()
        pdfContext.beginPage(nil)
        drawConclusions(conclusions: conclusions, context: pdfContext, rect: mediaBox)
        
        pdfContext.endPage()
        pdfContext.closePDF()
        
        return pdfData as Data
    }
    
    private static func drawTitle(theme: String, context: CGContext, rect: CGRect) {
        let title = "Relatório Oficial de Debate"
        let subtitle = "Tema: \(theme)"
        let dateStr = "Data: \(Date().description)"
        
        // Nota: No macOS real, usaríamos NSAttributedString e .draw(at:)
        // Como estou num ambiente CLI, estou a esboçar a lógica estrutural.
    }
    
    private static func drawHighlight(highlight: RoundHighlight, context: CGContext, startY: CGFloat, rect: CGRect) -> CGFloat {
        // Lógica de desenho de linha/tabela
        return startY - 100
    }
    
    private static func drawConclusions(conclusions: String, context: CGContext, rect: CGRect) {
        // Lógica de desenho de conclusões
    }
    
    static func savePDF(data: Data, theme: String) -> URL? {
        let fileName = "Debate_\(theme.replacingOccurrences(of: " ", with: "_"))_\(Date().timeIntervalSince1970).pdf"
        let historyPath = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Projetos/Bota_Faladura_Pro_Max/reports/history")
            .appendingPathComponent(fileName)
        
        do {
            try data.write(to: historyPath)
            return historyPath
        } catch {
            print("Erro ao guardar PDF: \(error)")
            return nil
        }
    }
}
