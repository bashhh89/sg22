'use client';

import React from 'react';
import Link from 'next/link';
import { Button } from '../components/ui/Button'; 

export default function HomePage() {
  return (
    <div className="min-h-screen bg-gradient-to-b from-gray-50 to-gray-100">
      <div className="container mx-auto px-4 py-16">
        <header className="mb-16 text-center">
          <h1 className="text-5xl font-bold mb-4 text-gray-900">
            AI Scorecard
          </h1>
          <p className="text-xl text-gray-600 max-w-3xl mx-auto">
            Generate comprehensive PDF scorecards for AI assessments. Analyze AI efficiency and provide detailed reports.
          </p>
        </header>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-8 mb-16">
          <div className="bg-white rounded-lg shadow-lg p-8">
            <h2 className="text-2xl font-bold mb-4 text-gray-800">Generate Reports</h2>
            <p className="text-gray-600 mb-6">
              Create detailed PDF reports based on AI assessment data. Our system analyzes the information and generates a comprehensive scorecard.
            </p>
            <div className="flex justify-center">
              <Button className="bg-blue-600 text-white hover:bg-blue-700" onClick={() => alert('This is a demo button. In the real app, this would start the report generation process.')}>
                Generate Report
              </Button>
            </div>
          </div>
          
          <div className="bg-white rounded-lg shadow-lg p-8">
            <h2 className="text-2xl font-bold mb-4 text-gray-800">View Sample</h2>
            <p className="text-gray-600 mb-6">
              See an example of our AI Efficiency Scorecard reports. Review the format, content, and detailed analytics included in each report.
            </p>
            <div className="flex justify-center">
              <Button className="bg-gray-600 text-white hover:bg-gray-700" onClick={() => alert('This is a demo button. In the real app, this would show a sample report.')}>
                View Sample
              </Button>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-lg shadow-lg p-8 mb-16">
          <h2 className="text-2xl font-bold mb-4 text-gray-800 text-center">Features</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="p-4">
              <h3 className="text-xl font-semibold mb-2 text-gray-700">Detailed Analytics</h3>
              <p className="text-gray-600">
                Comprehensive analysis of AI implementation efficiency across different business areas.
              </p>
            </div>
            <div className="p-4">
              <h3 className="text-xl font-semibold mb-2 text-gray-700">PDF Reports</h3>
              <p className="text-gray-600">
                Professionally formatted PDF reports that can be downloaded, shared, or printed.
              </p>
            </div>
            <div className="p-4">
              <h3 className="text-xl font-semibold mb-2 text-gray-700">Q&A Records</h3>
              <p className="text-gray-600">
                Complete record of assessment questions and answers included in each report.
              </p>
            </div>
          </div>
        </div>

        <footer className="text-center text-gray-500 text-sm">
          <p>&copy; {new Date().getFullYear()} AI Scorecard. All rights reserved.</p>
        </footer>
      </div>
    </div>
  );
} 