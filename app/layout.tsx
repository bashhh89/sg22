'use client';

import React from 'react';
import '../styles/globals.css'; // Ensure this file exists
import { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'AI Scorecard - PDF Report Generation',
  description: 'Professional PDF scorecards for AI efficiency assessments',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <head>
        <link rel="icon" href="/favicon.ico" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
      </head>
      <body className="bg-gray-50">
        <nav className="bg-gray-900 text-white p-4">
          <div className="container mx-auto flex justify-between items-center">
            <div className="text-xl font-bold">AI Scorecard</div>
            <div>
              {/* Navigation links here if needed */}
            </div>
          </div>
        </nav>
        <main>{children}</main>
      </body>
    </html>
  );
} 