// Example Component demonstrating Stock Analysis API usage
import { useState } from "react";
import { useStockAnalysis } from "../hooks/useStockAnalysis";
import { AnalysisDepth } from "../types/api";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Loader2, TrendingUp, TrendingDown, Minus } from "lucide-react";

export default function StockAnalysisDemo() {
  const [ticker, setTicker] = useState("AAPL");
  const [depth, setDepth] = useState<AnalysisDepth>(AnalysisDepth.QUICK);
  const { recommendation, loading, error, analyzeStock } = useStockAnalysis();

  const handleAnalyze = async () => {
    if (!ticker.trim()) return;
    try {
      await analyzeStock(ticker, depth);
    } catch (err) {
      console.error("Analysis failed:", err);
    }
  };

  const getRecommendationIcon = (rec: string) => {
    switch (rec) {
      case "BUY":
        return <TrendingUp className="h-6 w-6 text-green-500" />;
      case "SELL":
        return <TrendingDown className="h-6 w-6 text-red-500" />;
      case "HOLD":
        return <Minus className="h-6 w-6 text-yellow-500" />;
      default:
        return null;
    }
  };

  const getRecommendationColor = (rec: string) => {
    switch (rec) {
      case "BUY":
        return "text-green-600 bg-green-50";
      case "SELL":
        return "text-red-600 bg-red-50";
      case "HOLD":
        return "text-yellow-600 bg-yellow-50";
      default:
        return "";
    }
  };

  return (
    <div className="space-y-6 p-6">
      <Card>
        <CardHeader>
          <CardTitle>Stock Analysis</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="flex gap-4">
            <Input
              placeholder="Enter ticker (e.g., AAPL)"
              value={ticker}
              onChange={(e) => setTicker(e.target.value.toUpperCase())}
              className="flex-1"
            />
            <Select
              value={depth}
              onValueChange={(value) => setDepth(value as AnalysisDepth)}
            >
              <SelectTrigger className="w-[200px]">
                <SelectValue placeholder="Select depth" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value={AnalysisDepth.QUICK}>Quick</SelectItem>
                <SelectItem value={AnalysisDepth.STANDARD}>Standard</SelectItem>
                <SelectItem value={AnalysisDepth.COMPREHENSIVE}>
                  Comprehensive
                </SelectItem>
              </SelectContent>
            </Select>
            <Button onClick={handleAnalyze} disabled={loading || !ticker.trim()}>
              {loading ? (
                <>
                  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                  Analyzing...
                </>
              ) : (
                "Analyze"
              )}
            </Button>
          </div>

          {error && (
            <Alert variant="destructive">
              <AlertDescription>{error.message}</AlertDescription>
            </Alert>
          )}
        </CardContent>
      </Card>

      {recommendation && (
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              Investment Recommendation for {ticker}
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-6">
            {/* Recommendation Badge */}
            <div className="flex items-center gap-4">
              <div
                className={`flex items-center gap-2 px-6 py-3 rounded-lg font-bold text-lg ${getRecommendationColor(
                  recommendation.context.recommendation
                )}`}
              >
                {getRecommendationIcon(recommendation.context.recommendation)}
                {recommendation.context.recommendation}
              </div>
              <div className="text-sm text-muted-foreground">
                Confidence: {recommendation.context.confidence_score}%
              </div>
            </div>

            {/* Key Metrics */}
            <div className="grid grid-cols-2 gap-4">
              <div className="p-4 border rounded-lg">
                <div className="text-sm text-muted-foreground">Target Price</div>
                <div className="text-2xl font-bold text-green-600">
                  ${recommendation.context.target_price}
                </div>
              </div>
              <div className="p-4 border rounded-lg">
                <div className="text-sm text-muted-foreground">Stop Loss</div>
                <div className="text-2xl font-bold text-red-600">
                  ${recommendation.context.stop_loss}
                </div>
              </div>
            </div>

            {/* Reasoning */}
            <div className="space-y-2">
              <h3 className="font-semibold">Analysis</h3>
              <p className="text-sm text-muted-foreground leading-relaxed">
                {recommendation.context.reasoning}
              </p>
            </div>

            {/* Key Opportunities */}
            <div className="space-y-2">
              <h3 className="font-semibold flex items-center gap-2">
                <TrendingUp className="h-4 w-4 text-green-500" />
                Key Opportunities
              </h3>
              <ul className="list-disc list-inside space-y-1 text-sm text-muted-foreground">
                {recommendation.context.key_opportunities.map((opp, idx) => (
                  <li key={idx}>{opp}</li>
                ))}
              </ul>
            </div>

            {/* Key Risks */}
            <div className="space-y-2">
              <h3 className="font-semibold flex items-center gap-2">
                <TrendingDown className="h-4 w-4 text-red-500" />
                Key Risks
              </h3>
              <ul className="list-disc list-inside space-y-1 text-sm text-muted-foreground">
                {recommendation.context.key_risks.map((risk, idx) => (
                  <li key={idx}>{risk}</li>
                ))}
              </ul>
            </div>
          </CardContent>
        </Card>
      )}
    </div>
  );
}
