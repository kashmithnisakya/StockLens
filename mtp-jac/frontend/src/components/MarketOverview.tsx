import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { TrendingUp, TrendingDown, Activity } from "lucide-react";

const trendingStocks = [
  { symbol: "NVDA", name: "NVIDIA Corp", price: "$875.43", change: "+5.67%", isPositive: true, volume: "85.2M" },
  { symbol: "TSLA", name: "Tesla Inc", price: "$248.92", change: "+3.21%", isPositive: true, volume: "124.8M" },
  { symbol: "MSFT", name: "Microsoft Corp", price: "$415.67", change: "+1.89%", isPositive: true, volume: "22.4M" },
  { symbol: "GOOGL", name: "Alphabet Inc", price: "$142.38", change: "-0.45%", isPositive: false, volume: "18.7M" },
  { symbol: "AMZN", name: "Amazon.com Inc", price: "$178.25", change: "+2.34%", isPositive: true, volume: "45.9M" },
];

export const MarketOverview = () => {
  return (
    <Card className="bg-card/60 backdrop-blur-glass border-border/50 p-6">
      <div className="mb-6 flex items-center justify-between">
        <div className="flex items-center gap-2">
          <Activity className="h-5 w-5 text-primary" />
          <h3 className="text-xl font-bold">Trending Stocks</h3>
        </div>
        <Badge variant="secondary">Real-time</Badge>
      </div>

      <div className="space-y-3">
        {trendingStocks.map((stock) => (
          <div
            key={stock.symbol}
            className="flex items-center justify-between rounded-lg border border-border/50 bg-secondary/30 p-4 transition-all hover:bg-secondary/50 cursor-pointer"
          >
            <div className="flex items-center gap-4">
              <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10">
                {stock.isPositive ? (
                  <TrendingUp className="h-5 w-5 text-success" />
                ) : (
                  <TrendingDown className="h-5 w-5 text-destructive" />
                )}
              </div>
              <div>
                <p className="font-semibold">{stock.symbol}</p>
                <p className="text-xs text-muted-foreground">{stock.name}</p>
              </div>
            </div>

            <div className="flex items-center gap-6">
              <div className="text-right">
                <p className="text-sm text-muted-foreground">Volume</p>
                <p className="text-sm font-medium">{stock.volume}</p>
              </div>
              <div className="text-right">
                <p className="text-lg font-bold">{stock.price}</p>
                <p
                  className={`text-sm font-medium ${
                    stock.isPositive ? "text-success" : "text-destructive"
                  }`}
                >
                  {stock.change}
                </p>
              </div>
            </div>
          </div>
        ))}
      </div>
    </Card>
  );
};
