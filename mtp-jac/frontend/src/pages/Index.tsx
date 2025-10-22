import { Header } from "@/components/Header";
import { HeroSection } from "@/components/HeroSection";
import { StockMetrics } from "@/components/StockMetrics";
import { StockChart } from "@/components/StockChart";
import { MarketOverview } from "@/components/MarketOverview";

const Index = () => {
  return (
    <div className="min-h-screen bg-gradient-primary">
      <Header />
      <HeroSection />

      <main className="container mx-auto px-4 py-8 space-y-8">
        <StockMetrics />
        <StockChart />
        <MarketOverview />
      </main>
    </div>
  );
};

export default Index;
