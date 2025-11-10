import { createContext, useContext, useState, ReactNode } from "react";
import type { InvestmentRecommendation, AnalysisDepth } from "@/types/api";
import { stockAnalysisService } from "@/services/stock-analysis.service";

interface StockAnalysisContextType {
  recommendation: InvestmentRecommendation | null;
  resultId: string | null;
  ticker: string;
  loading: boolean;
  error: string | null;
  analyzeStock: (ticker: string, depth: AnalysisDepth | string) => Promise<void>;
  reset: () => void;
}

const StockAnalysisContext = createContext<StockAnalysisContextType | undefined>(
  undefined
);

export function StockAnalysisProvider({ children }: { children: ReactNode }) {
  const [recommendation, setRecommendation] = useState<InvestmentRecommendation | null>(null);
  const [resultId, setResultId] = useState<string | null>(null);
  const [ticker, setTicker] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const analyzeStock = async (tickerSymbol: string, depth: AnalysisDepth | string) => {
    setLoading(true);
    setError(null);
    setTicker(tickerSymbol.toUpperCase());

    try {
      const response = await stockAnalysisService.getStockAnalysis(tickerSymbol, depth);

      if (response.reports && response.reports.length > 0) {
        // Extract final_recommendation and result_id from the first report
        const report = response.reports[0];
        setRecommendation(report.final_recommendation);
        setResultId(report.result_id);
      } else {
        throw new Error("No analysis data received");
      }
    } catch (err: any) {
      const errorMessage = err.message || "Failed to analyze stock";
      setError(errorMessage);
      setRecommendation(null);
      setResultId(null);
      throw err;
    } finally {
      setLoading(false);
    }
  };

  const reset = () => {
    setRecommendation(null);
    setResultId(null);
    setTicker("");
    setError(null);
  };

  return (
    <StockAnalysisContext.Provider
      value={{
        recommendation,
        resultId,
        ticker,
        loading,
        error,
        analyzeStock,
        reset,
      }}
    >
      {children}
    </StockAnalysisContext.Provider>
  );
}

export function useStockAnalysisContext() {
  const context = useContext(StockAnalysisContext);
  if (context === undefined) {
    throw new Error(
      "useStockAnalysisContext must be used within a StockAnalysisProvider"
    );
  }
  return context;
}
