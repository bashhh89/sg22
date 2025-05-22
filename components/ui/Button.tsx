import React from 'react';

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'default' | 'primary' | 'secondary' | 'outline';
  size?: 'sm' | 'md' | 'lg';
  children: React.ReactNode;
}

export const Button = ({
  variant = 'default',
  size = 'md',
  className = '',
  children,
  ...props
}: ButtonProps) => {
  // Base styles
  const baseStyles = 'inline-flex items-center justify-center rounded-md font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:opacity-50 disabled:pointer-events-none';
  
  // Size styles
  const sizeStyles = {
    sm: 'h-9 px-3 text-xs',
    md: 'h-10 py-2 px-4 text-sm',
    lg: 'h-11 px-8 text-base',
  };
  
  // Variant styles
  const variantStyles = {
    default: 'bg-gray-900 text-white hover:bg-gray-800 focus-visible:ring-gray-950',
    primary: 'bg-blue-600 text-white hover:bg-blue-700 focus-visible:ring-blue-600',
    secondary: 'bg-gray-100 text-gray-900 hover:bg-gray-200 focus-visible:ring-gray-300',
    outline: 'border border-gray-200 bg-transparent hover:bg-gray-100 focus-visible:ring-gray-300',
  };
  
  const combinedClassName = `${baseStyles} ${sizeStyles[size]} ${variantStyles[variant]} ${className}`;
  
  return (
    <button className={combinedClassName} {...props}>
      {children}
    </button>
  );
}; 