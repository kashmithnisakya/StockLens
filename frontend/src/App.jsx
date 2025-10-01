import { useState } from 'react'
import ReactMarkdown from 'react-markdown'
import './App.css'

function App() {
  const [ticker, setTicker] = useState('AAPL')
  const [depth, setDepth] = useState('comprehensive')
  const [loading, setLoading] = useState(false)
  const [analysis, setAnalysis] = useState(null)
  const [error, setError] = useState(null)

  const analyzeStock = async () => {
    setLoading(true)
    setError(null)
    setAnalysis(null)

    try {
      const response = await fetch('http://0.0.0.0:8000/api/v1/analyze', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          ticker,
          depth,
        }),
      })

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }

      const data = await response.json()
      setAnalysis(data)
    } catch (err) {
      setError(err.message)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="app">
      <header className="app-header">
        <h1>StockLens</h1>
      </header>

      <div className="app-container">
        <div className="input-section">
          <div className="input-group">
            <label htmlFor="ticker">Stock Ticker</label>
            <input
              id="ticker"
              type="text"
              value={ticker}
              onChange={(e) => setTicker(e.target.value.toUpperCase())}
              placeholder="Enter ticker (e.g., AAPL)"
              autoComplete="off"
            />
          </div>

          <div className="input-group">
            <label htmlFor="depth">Analysis Depth</label>
            <select
              id="depth"
              value={depth}
              onChange={(e) => setDepth(e.target.value)}
            >
              <option value="quick">Quick Analysis</option>
              <option value="comprehensive">Comprehensive Analysis</option>
            </select>
          </div>

          <button
            onClick={analyzeStock}
            disabled={loading || !ticker}
            className="analyze-button"
          >
            {loading ? 'Analyzing...' : 'Analyze Stock'}
          </button>
        </div>

        {error && (
          <div className="error">
            <strong>Error:</strong> {error}
          </div>
        )}

        {analysis && (
          <div className="analysis-result">
            <h2>Analysis for {analysis.ticker}</h2>
            <div className="metadata">
              <p><strong>Status</strong> {analysis.status}</p>
              <p><strong>Depth</strong> {analysis.depth}</p>
              <p><strong>Timestamp</strong> {new Date(analysis.timestamp).toLocaleString()}</p>
            </div>
            <div className="analysis-content">
              <h3>Investment Analysis</h3>
              <div className="markdown-content">
                <ReactMarkdown>{analysis.analysis}</ReactMarkdown>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  )
}

export default App
