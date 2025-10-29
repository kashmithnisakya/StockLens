// Stock Analysis API Service
import { apiClient } from "./api-client";
import type {
  OrchestratorRequest,
  OrchestratorResponse,
  AnalysisDepth,
} from "../types/api";

class StockAnalysisService {
  /**
   * Fetch stock analysis and investment recommendation
   * @param ticker - Stock ticker symbol (e.g., "AAPL")
   * @param depth - Analysis depth: "quick", "standard", or "comprehensive"
   * @returns Investment recommendation with analysis details
   */
  async getStockAnalysis(
    ticker: string,
    depth: AnalysisDepth | string = "quick"
  ): Promise<OrchestratorResponse> {
    const payload: OrchestratorRequest = {
      ticker: ticker.toUpperCase(),
      depth,
    };

    return await apiClient.post<OrchestratorRequest, OrchestratorResponse>(
      "/walker/orchestrator",
      payload
    );
  }

  /**
   * Convenience method for quick analysis
   */
  async getQuickAnalysis(ticker: string): Promise<OrchestratorResponse> {
    return this.getStockAnalysis(ticker, "quick");
  }

  /**
   * Convenience method for standard analysis
   */
  async getStandardAnalysis(ticker: string): Promise<OrchestratorResponse> {
    return this.getStockAnalysis(ticker, "standard");
  }

  /**
   * Convenience method for comprehensive analysis
   */
  async getComprehensiveAnalysis(ticker: string): Promise<OrchestratorResponse> {
    return this.getStockAnalysis(ticker, "comprehensive");
  }
}

export const stockAnalysisService = new StockAnalysisService();
