# StockLens

AI-powered stock analysis platform using multi-agent AI systems.

## Overview

StockLens provides comprehensive stock analysis using specialized AI agents that analyze fundamentals, technicals, and market sentiment to deliver actionable investment recommendations.

## Project Structure

```
StockLens/
├── crewai-python/    # CrewAI-based backend implementation (Python)
├── mtp-jac/          # Jac-based backend implementation
└── README.md         # This file
```

## Implementations

This project contains two backend implementations:

1. **crewai-python**: Backend using CrewAI framework with FastAPI
2. **mtp-jac**: Backend using Jac language

Both implementations share a common frontend and provide similar stock analysis capabilities.

## Quick Start

Refer to the README files in each implementation folder for specific setup instructions:

- [CrewAI Python Backend](./crewai-python/README.md)
- [Jac Backend](./mtp-jac/README.md)

## Features

- Real-time stock analysis using AI agents
- Fundamental and technical analysis
- Market sentiment analysis
- Investment recommendations (BUY/HOLD/SELL)
- Modern React frontend
- RESTful API
- CLI interface

## Technology Stack

- Python/Jac (Backend)
- FastAPI (API Framework)
- CrewAI/Jac (Multi-agent orchestration)
- React (Frontend)
- OpenAI GPT-4 (Language Model)