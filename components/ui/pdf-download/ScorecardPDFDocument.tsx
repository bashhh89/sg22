'use client';

import React, { useEffect } from 'react';
import { pdfStyles } from './pdfStyles';
import { renderMarkdownContentAsHtml } from './markdownRenderer';

export interface ScorecardPDFDocumentProps {
  // Original props
  reportData?: {
    reportId: string;
    reportMarkdown: string;
    questionAnswerHistory: Array<{
      question: string;
      answer: string;
      reasoning?: string;
    }>;
    userName?: string;
    leadName?: string;
    leadCompany?: string;
    companyName?: string;
    industry?: string;
    userAITier?: string;
    tier?: string;
    finalScore?: number;
  };
  // Props expected by PDFDownloadButton
  data?: any;
  onGenerateComplete?: (pdfBlob: Blob) => void;
  onError?: (error: Error) => void;
}

export default function ScorecardPDFDocument({ 
  reportData, 
  data, 
  onGenerateComplete,
  onError 
}: ScorecardPDFDocumentProps) {
  // Use data prop if reportData is not provided
  const actualData = reportData || data;
  
  // Handle errors if the data is not in the expected format
  useEffect(() => {
    if (!actualData) {
      if (onError) onError(new Error('No data provided for PDF generation'));
      return;
    }
    
    try {
      // Simulate PDF generation (in a real app, this would use react-pdf or similar)
      setTimeout(() => {
        // Create a simple text blob as a placeholder for the PDF
        const pdfContent = `AI Scorecard PDF Content for ${JSON.stringify(actualData)}`;
        const blob = new Blob([pdfContent], { type: 'application/pdf' });
        
        if (onGenerateComplete) onGenerateComplete(blob);
      }, 500);
    } catch (error) {
      if (onError) onError(error instanceof Error ? error : new Error('Failed to generate PDF'));
    }
  }, [actualData, onGenerateComplete, onError]);

  // If no data is provided, don't render anything
  if (!actualData) return null;

  const {
    reportId = 'N/A',
    reportMarkdown = '',
    questionAnswerHistory = [],
    leadName = '',
    userName = '',
    leadCompany = '',
    companyName = '',
    industry = '',
    userAITier = '',
    tier = '',
    finalScore,
  } = actualData;

  const displayName = leadName || userName || 'Valued User';
  const displayCompany = leadCompany || companyName || 'N/A';
  const displayIndustry = industry || 'N/A';
  const displayTier = userAITier || tier || 'N/A';
  const displayScore = finalScore !== undefined && finalScore !== null ? finalScore.toFixed(1) : 'N/A';

  // Split the markdown content by h2 headers to create separate cards
  const splitContentByHeaders = (markdown: string) => {
    if (!markdown) return [''];
    
    // Split by h2 headers (## Header)
    const sections = markdown.split(/(?=^## )/m);
    
    // If there are no h2 headers or just one section, return as is
    if (sections.length <= 1) return [markdown];
    
    return sections;
  };

  const contentSections = splitContentByHeaders(reportMarkdown);

  return (
    <html>
      <head>
        <meta charSet="utf-8" />
        <title>AI Efficiency Scorecard</title>
        
        {/* Font loading status tracking */}
        <style dangerouslySetInnerHTML={{ __html: `
          :root {
            --font-loading-status: false;
          }
          
          /* Set font loading status to true once loaded */
          body {
            --font-loading-status: true;
          }
        `}} />
        
        {/* Main styles with embedded fonts */}
        <style>{pdfStyles}</style>
      </head>
      <body>
        <div className="header report-card">
          <h1>AI Efficiency Scorecard</h1>
          <p>Report for: {displayName}</p>
          <p>Company: {displayCompany}</p>
          <p>Industry: {displayIndustry}</p>
          <p>AI Maturity Tier: {displayTier}</p>
          {displayScore !== 'N/A' && <p>Final Score: {displayScore}</p>}
          <p className="report-id">Report ID: {reportId}</p>
          <p className="report-date">Generated: {new Date().toLocaleDateString()}</p>
        </div>

        {/* Overall Tier Section - First section gets special treatment */}
        {contentSections.length > 0 && (
          <div className="section">
            <div className="report-card">
              <div className="content">
                {renderMarkdownContentAsHtml(contentSections[0])}
              </div>
            </div>
          </div>
        )}

        {/* Render remaining content sections as separate cards */}
        {contentSections.slice(1).map((section, index) => (
          <div key={`section-${index + 1}`} className="section">
            <div className="report-card">
              <div className="content">
                {renderMarkdownContentAsHtml(section)}
              </div>
            </div>
          </div>
        ))}

        {/* Q&A History Section */}
        {questionAnswerHistory && questionAnswerHistory.length > 0 && (
          <div className="section">
            <div className="report-card">
              <div className="qa-section">
                <h2>Q&A History</h2>
                {questionAnswerHistory.map((qa, index) => (
                  <div key={index} className="qa-item">
                    <p><strong>Q:</strong> {qa.question}</p>
                    <p><strong>A:</strong> {qa.answer}</p>
                    {qa.reasoning && (
                      <p className="qa-reasoning">
                        <strong>Reasoning:</strong> {qa.reasoning}
                      </p>
                    )}
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}

        <div className="footer">
          <p>AI Efficiency Scorecard © {new Date().getFullYear()}</p>
          <p>This report is confidential and intended for the recipient only.</p>
        </div>
      </body>
    </html>
  );
} 