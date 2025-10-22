"""
Command Line Interface for Stock Analysis
"""
import argparse
from app.services.crew import StockAnalysisCrew
from app.core.config import SystemConfig

def main():
    """Main execution function for CLI"""

    # Parse command line arguments
    parser = argparse.ArgumentParser(description='Stock Market Analysis System')
    parser.add_argument('--ticker', type=str, help='Stock ticker to analyze')
    parser.add_argument('--tickers', type=str, nargs='+', help='Multiple tickers for batch analysis')
    parser.add_argument('--depth', type=str, default='comprehensive',
                       choices=['basic', 'standard', 'comprehensive'],
                       help='Analysis depth')

    args = parser.parse_args()

    # Validate configuration
    try:
        SystemConfig.validate()
    except ValueError as e:
        print(f"Configuration Error: {e}")
        print("Please set required environment variables in .env file")
        return

    # Initialize crew
    crew = StockAnalysisCrew()

    # Execute analysis
    if args.tickers:
        # Batch analysis
        print(f"Analyzing multiple stocks: {', '.join(args.tickers)}")
        results = crew.batch_analyze(args.tickers, args.depth)

        for ticker, analysis in results.items():
            print(f"\n{'='*80}")
            print(f"Analysis for {ticker}")
            print(f"{'='*80}")
            print(analysis)

    elif args.ticker:
        # Single stock analysis
        result = crew.analyze(args.ticker, args.depth)
        print("\n" + "="*80)
        print("FINAL ANALYSIS REPORT")
        print("="*80)
        print(result)

    else:
        # Default example
        print("No ticker specified. Running example analysis for AAPL...")
        result = crew.analyze("AAPL", args.depth)
        print("\n" + "="*80)
        print("FINAL ANALYSIS REPORT")
        print("="*80)
        print(result)


if __name__ == "__main__":
    main()
