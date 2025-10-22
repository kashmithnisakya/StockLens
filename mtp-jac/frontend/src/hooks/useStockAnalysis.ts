// React Hook for Stock Analysis
import { useState } from "react";
import { stockAnalysisService } from "../services/stock-analysis.service";
import type {
  OrchestratorResponse,
  InvestmentRecommendation,
  AnalysisDepth,
  ApiError,
} from "../types/api";

interface UseStockAnalysisState {
  data: OrchestratorResponse | null;
  recommendation: InvestmentRecommendation | null;
  loading: boolean;
  error: ApiError | null;
}

export function useStockAnalysis() {
  const [state, setState] = useState<UseStockAnalysisState>({
    data: null,
    recommendation: null,
    loading: false,
    error: null,
  });

  const analyzeStock = async (
    ticker: string,
    depth: AnalysisDepth | string = "quick"
  ) => {
    setState((prev) => ({
      ...prev,
      loading: true,
      error: null,
    }));

    try {
      const response = await stockAnalysisService.getStockAnalysis(
        ticker,
        depth
      );

      setState({
        data: response,
        recommendation: response.reports[0] || null,
        loading: false,
        error: null,
      });

      return response;
    } catch (err: any) {
      const apiError: ApiError = {
        message: err.message || "Failed to analyze stock",
        status: err.status,
        details: err.details,
      };

      setState({
        data: null,
        recommendation: null,
        loading: false,
        error: apiError,
      });

      throw apiError;
    }
  };

  const reset = () => {
    setState({
      data: null,
      recommendation: null,
      loading: false,
      error: null,
    });
  };

  return {
    ...state,
    analyzeStock,
    reset,
  };
}
