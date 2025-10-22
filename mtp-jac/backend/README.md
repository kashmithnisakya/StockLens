# StockLens Backend - Jac Implementation

AI-powered stock analysis system built with Jac language.

## Overview

This backend uses Jac (Jaclang) to implement a multi-agent AI system for comprehensive stock analysis. The system leverages AI agents to analyze stocks and provide investment recommendations.

## Project Structure

```
backend/
├── app/
│   ├── main.jac                  # Application entry point
│   ├── agent_orchestrator.jac    # Multi-agent orchestration
│   ├── ai_core.jac               # AI/LLM integration
│   ├── nodes.jac                 # Node definitions and data structures
│   └── serper_client.jac         # Web search integration
├── requirements.txt              # Python dependencies
└── README.md                     # This file
```

## Prerequisites

- Python 3.12+
- Jaclang installed
- OpenAI API key (or other LLM provider)
- Serper API key (for web search)

## Installation

```bash
# Install dependencies
pip install -r requirements.txt

# Configure environment variables
export OPENAI_API_KEY=your_openai_api_key
export SERPER_API_KEY=your_serper_api_key
```

## Running the Application

```bash
cd app
jac run main.jac
```

## Key Components

- **main.jac**: Entry point for the application
- **agent_orchestrator.jac**: Coordinates multiple AI agents for stock analysis
- **ai_core.jac**: Handles LLM integration and AI functionality
- **nodes.jac**: Defines data structures and graph nodes
- **serper_client.jac**: Integrates web search capabilities

## Features

- Multi-agent AI architecture
- Knowledge base integration
- Real-time stock analysis
- Investment recommendations
- Web search integration for market data

## Technology Stack

- Jaclang - Programming language and framework
- jac-cloud - Cloud framework
- OpenAI API - Language model
- Serper API - Web search
