import React from 'react';
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'AI Scorecard',
  description: 'Generate PDF scorecards for AI assessments',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
} 