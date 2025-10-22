import { useState, useEffect } from "react";
import { Header } from "@/components/Header";
import { Card } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Loader2, Search } from "lucide-react";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { StockAnalysisResults } from "@/components/StockAnalysisResults";
import { AIChat } from "@/components/AIChat";
import { useStockAnalysisContext } from "@/contexts/StockAnalysisContext";
import { AnalysisDepth } from "@/types/api";
import { useToast } from "@/hooks/use-toast";

const AnalyticsContent = () => {
  // Prevent body scroll
  useEffect(() => {
    document.body.style.overflow = 'hidden';
    return () => {
      document.body.style.overflow = 'unset';
    };
  }, []);
  const [ticker, setTicker] = useState("");
  const [depth, setDepth] = useState<AnalysisDepth>(AnalysisDepth.QUICK);
  const { recommendation, ticker: analyzedTicker, loading, analyzeStock } = useStockAnalysisContext();
  const { toast } = useToast();

  const handleAnalyze = async () => {
    if (!ticker.trim()) {
      toast({
        title: "Ticker Required",
        description: "Please enter a stock ticker symbol",
        variant: "destructive",
      });
      return;
    }

    try {
      await analyzeStock(ticker, depth);
      toast({
        title: "Analysis Complete",
        description: `Successfully analyzed ${ticker}`,
      });
    } catch (error: any) {
      toast({
        title: "Analysis Failed",
        description: error.message || "Failed to analyze stock",
        variant: "destructive",
      });
    }
  };

  return (
    <div className="h-screen bg-gradient-primary flex flex-col overflow-hidden">
      <Header />

      <main className="container mx-auto px-4 py-6 flex-1 min-h-0">
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 h-full">
          {/* Left side - 2/3 width - Stock Analysis */}
          <div className="lg:col-span-2 flex flex-col h-full gap-6 min-h-0">
            {/* Search Section - Pinned at top */}
            <Card className="bg-card/80 backdrop-blur-glass border-border/50 p-6 flex-shrink-0">
              <div className="space-y-4">
                <div>
                  <h2 className="text-2xl font-bold mb-2">Stock Analysis</h2>
                  <p className="text-sm text-muted-foreground">
                    Enter a stock ticker to get AI-powered investment recommendations
                  </p>
                </div>

                <div className="flex flex-col gap-3 sm:flex-row">
                  <Input
                    placeholder="Enter stock ticker (e.g., AAPL, GOOGL, MSFT)"
                    value={ticker}
                    onChange={(e) => setTicker(e.target.value.toUpperCase())}
                    onKeyDown={(e) => e.key === "Enter" && handleAnalyze()}
                    className="flex-1"
                  />
                  <Select
                    value={depth}
                    onValueChange={(value) => setDepth(value as AnalysisDepth)}
                  >
                    <SelectTrigger className="w-full sm:w-[180px]">
                      <SelectValue placeholder="Analysis depth" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value={AnalysisDepth.QUICK}>Quick</SelectItem>
                      <SelectItem value={AnalysisDepth.STANDARD}>Standard</SelectItem>
                      <SelectItem value={AnalysisDepth.COMPREHENSIVE}>
                        Comprehensive
                      </SelectItem>
                    </SelectContent>
                  </Select>
                  <Button
                    onClick={handleAnalyze}
                    disabled={loading || !ticker.trim()}
                    className="w-full sm:w-auto"
                  >
                    {loading ? (
                      <>
                        <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                        Analyzing...
                      </>
                    ) : (
                      <>
                        <Search className="mr-2 h-4 w-4" />
                        Analyze
                      </>
                    )}
                  </Button>
                </div>
              </div>
            </Card>

            {/* Scrollable Results Section */}
            <div className="flex-1 overflow-hidden min-h-0">
              {/* Analysis Results */}
              {recommendation && analyzedTicker && (
                <StockAnalysisResults recommendation={recommendation} ticker={analyzedTicker} />
              )}

              {/* Empty State */}
              {!recommendation && (
                <Card className="bg-card/60 backdrop-blur-glass border-border/50 p-12">
                  <div className="text-center space-y-3">
                    <div className="flex justify-center">
                      <div className="h-16 w-16 rounded-full bg-primary/10 flex items-center justify-center">
                        <Search className="h-8 w-8 text-primary" />
                      </div>
                    </div>
                    <h3 className="text-xl font-semibold">No Analysis Yet</h3>
                    <p className="text-muted-foreground max-w-md mx-auto">
                      Enter a stock ticker above and click "Analyze" to get AI-powered investment
                      recommendations powered by multi-agent analysis.
                    </p>
                  </div>
                </Card>
              )}
            </div>
          </div>

          {/* Right side - 1/3 width - AI Chat */}
          <div className="lg:col-span-1 h-full">
            <AIChat />
          </div>
        </div>
      </main>
    </div>
  );
};

const Analytics = () => {
  return <AnalyticsContent />;
};

export default Analytics;
