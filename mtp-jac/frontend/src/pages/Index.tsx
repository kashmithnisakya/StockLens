import { Header } from "@/components/Header";
import { HeroSection } from "@/components/HeroSection";
import { StockMetrics } from "@/components/StockMetrics";
import { StockChart } from "@/components/StockChart";
import { AIChat } from "@/components/AIChat";
import { MarketOverview } from "@/components/MarketOverview";

const Index = () => {
  return (
    <div className="min-h-screen bg-gradient-primary">
      <Header />
      <HeroSection />
      
      <main className="container mx-auto px-4 py-8 space-y-8">
        <StockMetrics />
        
        <div className="grid grid-cols-1 gap-8 lg:grid-cols-3">
          <div className="lg:col-span-2 space-y-8">
            <StockChart />
            <MarketOverview />
          </div>
          
          <div className="lg:col-span-1">
            <AIChat />
          </div>
        </div>
      </main>
    </div>
  );
};

export default Index;
