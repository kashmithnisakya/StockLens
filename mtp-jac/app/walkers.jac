# Walker for Market Researcher agent
walker ResearchMarket {
    has ticker: str;
    has depth: str;

    can gather_data with MarketResearcher entry {
        here.status = "researching";

        # Create research prompt
        prompt = f"""
        Research the stock {self.ticker} and gather the following information:
        1. Current market data (price, volume, market cap)
        2. Recent news and developments
        3. Industry trends
        4. Competitor analysis

        Provide a comprehensive summary in JSON format with keys:
        - market_data
        - news
        - industry_trends
        - competitors
        """;

        # Call LLM for research
        research_result = llm.reason(prompt);

        # Store research data
        here.research_data = {
            "raw_data": research_result,
            "ticker": self.ticker,
            "timestamp": datetime.now().isoformat()
        };

        here.status = "completed";

        # Pass data to knowledge base
        knowledge_base = [n for n in -->MasterAgent-->KnowledgeBase][0];
        visit knowledge_base;
    }

    can update_knowledge with KnowledgeBase entry {
        # Get research data from researcher
        researcher = [n for n in -->MasterAgent-->MarketResearcher][0];

        here.market_data = researcher.research_data;
        here.news_data = researcher.research_data.get("news", []);
    }
}

# Walker for Stock Analyst agent
walker AnalyzeStock {
    has ticker: str;
    has depth: str;

    can analyze_fundamentals with StockAnalyst entry {
        here.status = "analyzing";

        # Get knowledge base data
        knowledge_base = [n for n in -->MasterAgent-->KnowledgeBase][0];
        market_data = knowledge_base.market_data;

        # Create analysis prompt
        prompt = f"""
        You are an expert Stock Analyst. Analyze {self.ticker} based on:

        Market Data: {market_data}

        Provide a detailed analysis covering:
        1. Fundamental Analysis (P/E ratio, revenue, profitability)
        2. Technical Analysis (price trends, support/resistance)
        3. Sentiment Analysis (market sentiment, news sentiment)

        Analysis Depth: {self.depth}

        Return your analysis in a structured format with sections:
        - fundamentals
        - technicals
        - sentiment
        - summary
        """;

        # Call LLM for analysis
        analysis_result = llm.reason(prompt);

        # Store analysis
        here.analysis_result = {
            "fundamentals": analysis_result,
            "ticker": self.ticker,
            "timestamp": datetime.now().isoformat()
        };

        here.status = "completed";

        # Update knowledge base
        knowledge_base.fundamental_data = here.analysis_result.get("fundamentals", {});
        knowledge_base.technical_data = here.analysis_result.get("technicals", {});
        knowledge_base.sentiment_data = here.analysis_result.get("sentiment", {});
    }
}

# Walker for Investment Strategist agent
walker GenerateRecommendation {
    has ticker: str;

    can create_recommendation with InvestmentStrategist entry {
        here.status = "strategizing";

        # Get all analysis data from knowledge base
        knowledge_base = [n for n in -->MasterAgent-->KnowledgeBase][0];

        # Create recommendation prompt
        prompt = f"""
        You are a Senior Investment Strategist. Based on the following analysis for {self.ticker}:

        Fundamental Data: {knowledge_base.fundamental_data}
        Technical Data: {knowledge_base.technical_data}
        Sentiment Data: {knowledge_base.sentiment_data}
        Market Data: {knowledge_base.market_data}
        News: {knowledge_base.news_data}

        Provide a clear investment recommendation:
        1. Recommendation: BUY, HOLD, or SELL
        2. Confidence Score: 0-100
        3. Reasoning: Detailed explanation
        4. Key Risks: List of potential risks
        5. Key Opportunities: List of potential opportunities
        6. Target Price (if BUY)
        7. Stop Loss (if BUY)

        Format as JSON with these exact keys.
        """;

        # Call LLM for recommendation
        recommendation_result = llm.reason(prompt);

        # Store recommendation
        here.recommendation = recommendation_result.get("recommendation", "HOLD");
        here.reasoning = recommendation_result.get("reasoning", "");
        here.status = "completed";

        # Create final analysis result
        result_node = AnalysisResult(
            ticker=self.ticker,
            recommendation=here.recommendation,
            confidence_score=recommendation_result.get("confidence_score", 0.0),
            analysis_summary=here.reasoning,
            key_metrics=knowledge_base.fundamental_data,
            risks=recommendation_result.get("risks", []),
            opportunities=recommendation_result.get("opportunities", []),
            timestamp=datetime.now().isoformat()
        );

        # Connect result to master
        master = [n for n in -->MasterAgent][0];
        master ++> result_node;
        visit master;
    }

    can finalize_analysis with MasterAgent entry {
        # Get the analysis result
        result = [n for n in -->AnalysisResult][0];

        # Compile final analysis
        here.final_analysis = {
            "ticker": self.ticker,
            "status": "success",
            "recommendation": result.recommendation,
            "confidence": result.confidence_score,
            "summary": result.analysis_summary,
            "metrics": result.key_metrics,
            "risks": result.risks,
            "opportunities": result.opportunities,
            "timestamp": result.timestamp
        };

        here.status = "completed";
    }
}

# Main orchestrator walker
walker OrchestrateAnalysis {
    has ticker: str;
    has depth: str = "comprehensive";
    has result: dict = {};

    can start_analysis with MasterAgent entry {
        # Initialize the analysis system
        init_walker = InitAnalysis(ticker=self.ticker, depth=self.depth);
        init_walker spawn here;

        # Phase 1: Market Research
        research_walker = ResearchMarket(ticker=self.ticker, depth=self.depth);
        researcher = [n for n in -->MarketResearcher][0];
        research_walker spawn researcher;

        # Phase 2: Stock Analysis
        analysis_walker = AnalyzeStock(ticker=self.ticker, depth=self.depth);
        analyst = [n for n in -->StockAnalyst][0];
        analysis_walker spawn analyst;

        # Phase 3: Generate Recommendation
        recommendation_walker = GenerateRecommendation(ticker=self.ticker);
        strategist = [n for n in -->InvestmentStrategist][0];
        recommendation_walker spawn strategist;

        # Get final result
        self.result = here.final_analysis;
    }
}

# Walker for batch analysis
walker BatchAnalysis {
    has tickers: list;
    has depth: str = "comprehensive";
    has results: list = [];

    can analyze_multiple with MasterAgent entry {
        for ticker in self.tickers {
            # Create a new master agent for each ticker
            master = MasterAgent();
            orchestrator = OrchestrateAnalysis(ticker=ticker, depth=self.depth);
            orchestrator spawn master;

            # Collect result
            self.results.append(orchestrator.result);
        }
    }
}

# Walker to query analysis results
walker QueryResult {
    has ticker: str;
    has result: dict = {};

    can get_result with MasterAgent entry {
        if here.ticker == self.ticker and here.status == "completed" {
            self.result = here.final_analysis;
        }
    }
}
