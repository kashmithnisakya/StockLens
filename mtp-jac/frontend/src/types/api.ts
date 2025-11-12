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

export interface AnalysisReport {
  result_id: string;
  ticker: string;
  final_recommendation: InvestmentRecommendation;
}

export interface OrchestratorResponse {
  status: number;
  reports: AnalysisReport[];
}

export interface ApiError {
  message: string;
  status?: number;
  details?: any;
}

// Chat API Types
export interface ChatMessage {
  question: string;
  response: string;
  timestamp: string;
}

export interface ChatRequest {
  result_id: string;
  quary: string; // Note: API uses "quary" (typo in backend)
}

export interface ChatReport {
  result_id: string;
  answer: string;
  chat_history: ChatMessage[];
}

export interface ChatResponse {
  status: number;
  reports: ChatReport[];
}
