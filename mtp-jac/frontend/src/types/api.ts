// API Request and Response Types

export enum AnalysisDepth {
  QUICK = "quick",
  STANDARD = "standard",
  COMPREHENSIVE = "comprehensive"
}

export interface OrchestratorRequest {
  ticker: string;
  depth: AnalysisDepth | string;
}

export interface InvestmentRecommendation {
  id: string;
  context: {
    recommendation: "BUY" | "SELL" | "HOLD";
    confidence_score: number;
    reasoning: string;
    key_risks: string[];
    key_opportunities: string[];
    target_price: number;
    stop_loss: number;
  };
}

export interface OrchestratorResponse {
  status: number;
  reports: InvestmentRecommendation[];
}

export interface ApiError {
  message: string;
  status?: number;
  details?: any;
}
