import { Search, TrendingUp, Bot } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";

export const Header = () => {
  return (
    <header className="sticky top-0 z-50 border-b border-border/50 bg-card/80 backdrop-blur-xl">
      <div className="container mx-auto px-4 py-4">
        <div className="flex items-center justify-between gap-4">
          <div className="flex items-center gap-2">
            <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary shadow-glow">
              <TrendingUp className="h-6 w-6 text-primary-foreground" />
            </div>
            <div className="flex flex-col">
              <h1 className="text-xl font-bold tracking-tight">MarketMind AI</h1>
              <p className="text-xs text-muted-foreground">Intelligent Stock Analysis</p>
            </div>
          </div>
          
          <div className="flex flex-1 max-w-xl items-center gap-2">
            <div className="relative flex-1">
              <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
              <Input
                type="text"
                placeholder="Search any stock ticker (e.g., AAPL, TSLA, MSFT)..."
                className="pl-10 bg-secondary border-border/50"
              />
            </div>
            <Button variant="hero" size="default">
              Analyze
            </Button>
          </div>

          <Button variant="glass" size="icon">
            <Bot className="h-5 w-5" />
          </Button>
        </div>
      </div>
    </header>
  );
};
