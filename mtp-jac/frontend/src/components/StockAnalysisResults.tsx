import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { TrendingUp, TrendingDown, Minus, Target, Shield } from "lucide-react";
import type { InvestmentRecommendation } from "@/types/api";

interface StockAnalysisResultsProps {
  recommendation: InvestmentRecommendation;
  ticker: string;
}

export const StockAnalysisResults = ({ recommendation, ticker }: StockAnalysisResultsProps) => {
  const getRecommendationIcon = (rec: string) => {
    switch (rec) {
      case "BUY":
        return <TrendingUp className="h-6 w-6" />;
      case "SELL":
        return <TrendingDown className="h-6 w-6" />;
      case "HOLD":
        return <Minus className="h-6 w-6" />;
      default:
        return null;
    }
  };

  const getRecommendationColor = (rec: string) => {
    switch (rec) {
      case "BUY":
        return "bg-green-500/10 text-green-600 border-green-500/20";
      case "SELL":
        return "bg-red-500/10 text-red-600 border-red-500/20";
      case "HOLD":
        return "bg-yellow-500/10 text-yellow-600 border-yellow-500/20";
      default:
        return "";
    }
  };

  return (
    <Card className="bg-card/80 backdrop-blur-glass border-border/50 flex flex-col max-h-full">
      <CardHeader className="flex-shrink-0">
        <CardTitle className="flex items-center justify-between">
          <span>Investment Analysis: {ticker}</span>
          <Badge variant="secondary" className="text-xs">
            Confidence: {recommendation.context.confidence_score}%
          </Badge>
        </CardTitle>
      </CardHeader>
      <CardContent className="space-y-6 overflow-y-auto custom-scrollbar flex-1">
        {/* Recommendation Badge */}
        <div className="flex items-center justify-center">
          <div
            className={`flex items-center gap-3 px-8 py-4 rounded-xl font-bold text-xl border-2 ${getRecommendationColor(
              recommendation.context.recommendation
            )}`}
          >
            {getRecommendationIcon(recommendation.context.recommendation)}
            {recommendation.context.recommendation}
          </div>
        </div>

        {/* Key Metrics Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <Card className="bg-green-500/5 border-green-500/20">
            <CardContent className="pt-6">
              <div className="flex items-start gap-3">
                <Target className="h-5 w-5 text-green-600 mt-1" />
                <div>
                  <p className="text-sm text-muted-foreground">Target Price</p>
                  <p className="text-3xl font-bold text-green-600">
                    ${recommendation.context.target_price}
                  </p>
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-red-500/5 border-red-500/20">
            <CardContent className="pt-6">
              <div className="flex items-start gap-3">
                <Shield className="h-5 w-5 text-red-600 mt-1" />
                <div>
                  <p className="text-sm text-muted-foreground">Stop Loss</p>
                  <p className="text-3xl font-bold text-red-600">
                    ${recommendation.context.stop_loss}
                  </p>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Analysis Reasoning */}
        <div className="space-y-2">
          <h3 className="font-semibold text-lg">Market Analysis</h3>
          <p className="text-sm text-muted-foreground leading-relaxed">
            {recommendation.context.reasoning}
          </p>
        </div>

        {/* Key Opportunities */}
        <div className="space-y-3">
          <h3 className="font-semibold text-lg flex items-center gap-2">
            <TrendingUp className="h-5 w-5 text-green-500" />
            Key Opportunities
          </h3>
          <ul className="space-y-2">
            {recommendation.context.key_opportunities.map((opp, idx) => (
              <li key={idx} className="flex items-start gap-2 text-sm">
                <span className="text-green-500 mt-1">•</span>
                <span className="text-muted-foreground">{opp}</span>
              </li>
            ))}
          </ul>
        </div>

        {/* Key Risks */}
        <div className="space-y-3">
          <h3 className="font-semibold text-lg flex items-center gap-2">
            <TrendingDown className="h-5 w-5 text-red-500" />
            Key Risks
          </h3>
          <ul className="space-y-2">
            {recommendation.context.key_risks.map((risk, idx) => (
              <li key={idx} className="flex items-start gap-2 text-sm">
                <span className="text-red-500 mt-1">•</span>
                <span className="text-muted-foreground">{risk}</span>
              </li>
            ))}
          </ul>
        </div>
      </CardContent>
    </Card>
  );
};
