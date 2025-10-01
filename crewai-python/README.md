# Stock Analysis API

AI-powered stock analysis system using CrewAI multi-agent framework and FastAPI.

## 📁 Project Structure

```
crewai-python/
├── app/
│   ├── __init__.py
│   ├── api/
│   │   ├── __init__.py
│   │   └── routes.py          # FastAPI endpoints
│   ├── core/
│   │   ├── __init__.py
│   │   └── config.py          # Configuration and settings
│   ├── models/
│   │   ├── __init__.py
│   │   └── schemas.py         # Pydantic models
│   └── services/
│       ├── __init__.py
│       ├── agents.py          # CrewAI agents
│       ├── tasks.py           # CrewAI tasks
│       └── crew.py            # Crew orchestration
├── main.py                     # FastAPI server entry point
├── cli.py                      # Command-line interface
├── requirements.txt            # Project dependencies
├── README.md                   # Documentation
└── .env                        # Environment variables (create this)

```

## 🚀 Quick Start

### 1. Install Dependencies

```bash
pip install -r requirements.txt
```

### 2. Configure Environment

Create a `.env` file in the project root:

```env
OPENAI_API_KEY=your_openai_api_key
SERPER_API_KEY=your_serper_api_key
```

### 3. Run the API Server

```bash
python main.py
```

The API will be available at `http://localhost:8000`

### 4. Run CLI (Optional)

```bash
# Analyze single stock
python cli.py --ticker AAPL --depth comprehensive

# Analyze multiple stocks
python cli.py --tickers AAPL GOOGL MSFT --depth standard
```

## 📚 API Endpoints

### Health Check
- `GET /` - Root health check
- `GET /health` - Detailed health status

### Stock Analysis
- `POST /api/v1/analyze` - Analyze a single stock
- `GET /api/v1/analyze/{ticker}` - Analyze stock via GET
- `POST /api/v1/analyze/batch` - Analyze multiple stocks

### Example Request

```bash
curl -X POST "http://localhost:8000/api/v1/analyze" \
  -H "Content-Type: application/json" \
  -d '{
    "ticker": "AAPL",
    "depth": "comprehensive"
  }'
```

## 🔧 Configuration

Edit `app/core/config.py` to customize:

- **LLM Model**: Default is `gpt-4o-mini` (fast & cheap)
- **Max Iterations**: Limit agent iterations to 3
- **Analysis Depth**: basic, standard, comprehensive
- **Rate Limits**: Max 10 requests per minute

## 🤖 Architecture

### Agents
- **Stock Analyst**: Analyzes fundamentals, technicals, and sentiment
- **Investment Strategist**: Provides BUY/HOLD/SELL recommendations

### Tasks
1. **Analysis Task**: Gather key metrics and news
2. **Recommendation Task**: Generate investment recommendation

## 📖 API Documentation

Once the server is running, visit:
- Swagger UI: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

## ⚡ Performance Optimizations

- Uses `gpt-4o-mini` (10x faster than GPT-4)
- Reduced from 5 to 2 agents
- Simplified task descriptions
- Disabled crew memory for faster execution
- Limited iterations to prevent timeouts

## 🛠️ Development

```bash
# Run with auto-reload
python main.py

# Run tests (if available)
pytest

# Format code
black app/
```

## 📝 License

MIT
