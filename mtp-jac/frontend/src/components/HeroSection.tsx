import { TrendingUp, ArrowUpRight, ArrowDownRight } from "lucide-react";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";

export const HeroSection = () => {
  const marketData = [
    { symbol: "S&P 500", value: "4,783.45", change: "+1.24%", isPositive: true },
    { symbol: "DOW", value: "37,440.34", change: "+0.87%", isPositive: true },
    { symbol: "NASDAQ", value: "15,043.97", change: "-0.34%", isPositive: false },
  ];

  return (
    <section className="relative overflow-hidden border-b border-border/50">
      {/* Gradient glow background */}
      <div className="absolute inset-0 bg-gradient-glow opacity-50" />
      
      <div className="container relative mx-auto px-4 py-12">
        <div className="flex flex-col items-center text-center">
          <Badge variant="secondary" className="mb-4 px-4 py-1.5">
            <TrendingUp className="mr-2 h-3 w-3" />
            Powered by Multi-AI Agents
          </Badge>
          
          <h2 className="mb-4 text-5xl font-bold tracking-tight bg-gradient-to-r from-primary via-accent to-primary bg-clip-text text-transparent">
            Real-Time Stock Market Intelligence
          </h2>
          
          <p className="mb-8 max-w-2xl text-lg text-muted-foreground">
            Leverage advanced AI agents to analyze market trends, predict movements, 
            and make data-driven investment decisions with confidence.
          </p>

          <div className="grid w-full max-w-4xl grid-cols-1 gap-4 md:grid-cols-3">
            {marketData.map((market) => (
              <Card key={market.symbol} className="bg-card/60 backdrop-blur-glass border-border/50 p-6">
                <div className="flex items-start justify-between">
                  <div>
                    <p className="text-sm text-muted-foreground">{market.symbol}</p>
                    <p className="mt-1 text-2xl font-bold">{market.value}</p>
                  </div>
                  {market.isPositive ? (
                    <ArrowUpRight className="h-5 w-5 text-success" />
                  ) : (
                    <ArrowDownRight className="h-5 w-5 text-destructive" />
                  )}
                </div>
                <p className={`mt-2 text-sm font-medium ${market.isPositive ? 'text-success' : 'text-destructive'}`}>
                  {market.change}
                </p>
              </Card>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
};
