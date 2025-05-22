import React from 'react';

export default function HomePage() {
  return (
    <div className="flex flex-col items-center justify-center min-h-screen py-2">
      <main className="flex flex-col items-center justify-center flex-1 px-20 text-center">
        <h1 className="text-6xl font-bold">
          Welcome to{' '}
          <span className="text-blue-600">
            AI Scorecard
          </span>
        </h1>
        <p className="mt-3 text-2xl">
          Generate PDF scorecards for AI assessments
        </p>
      </main>
    </div>
  );
} 