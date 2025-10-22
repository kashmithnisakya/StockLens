import { Card } from "@/components/ui/card";
import { DollarSign, BarChart3, PieChart, TrendingUp } from "lucide-react";

export const StockMetrics = () => {
  const metrics = [
    { label: "Market Cap", value: "$2.98T", icon: DollarSign, trend: "+2.4%" },
    { label: "P/E Ratio", value: "29.84", icon: BarChart3, trend: "+0.8%" },
    { label: "52W High", value: "$199.62", icon: TrendingUp, trend: "-4.2%" },
    { label: "Dividend Yield", value: "0.52%", icon: PieChart, trend: "+0.1%" },
  ];

  return (
    <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
      {metrics.map((metric) => (
        <Card
          key={metric.label}
          className="bg-card/60 backdrop-blur-glass border-border/50 p-6 transition-all hover:shadow-glow"
        >
          <div className="flex items-start justify-between">
            <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10">
              <metric.icon className="h-5 w-5 text-primary" />
            </div>
            <span className="text-xs font-medium text-muted-foreground">{metric.trend}</span>
          </div>
          <div className="mt-4">
            <p className="text-sm text-muted-foreground">{metric.label}</p>
            <p className="mt-1 text-2xl font-bold">{metric.value}</p>
          </div>
        </Card>
      ))}
    </div>
  );
};
