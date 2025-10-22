import { Card } from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { LineChart, Line, AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from "recharts";

const mockData = [
  { time: "09:30", price: 185.42, volume: 12500 },
  { time: "10:00", price: 186.21, volume: 15200 },
  { time: "10:30", price: 185.89, volume: 11800 },
  { time: "11:00", price: 187.15, volume: 18900 },
  { time: "11:30", price: 188.34, volume: 21300 },
  { time: "12:00", price: 187.92, volume: 16700 },
  { time: "12:30", price: 189.45, volume: 22100 },
  { time: "13:00", price: 190.12, volume: 24500 },
  { time: "13:30", price: 189.78, volume: 19800 },
  { time: "14:00", price: 191.25, volume: 27300 },
];

export const StockChart = () => {
  return (
    <Card className="bg-card/60 backdrop-blur-glass border-border/50 p-6">
      <div className="mb-6 flex items-center justify-between">
        <div>
          <h3 className="text-2xl font-bold">AAPL</h3>
          <p className="text-sm text-muted-foreground">Apple Inc.</p>
        </div>
        <div className="text-right">
          <p className="text-3xl font-bold">$191.25</p>
          <p className="text-sm font-medium text-success">+5.83 (+3.14%)</p>
        </div>
      </div>

      <Tabs defaultValue="price" className="w-full">
        <TabsList className="grid w-full grid-cols-2 bg-secondary">
          <TabsTrigger value="price">Price Chart</TabsTrigger>
          <TabsTrigger value="volume">Volume</TabsTrigger>
        </TabsList>
        
        <TabsContent value="price" className="mt-6">
          <ResponsiveContainer width="100%" height={350}>
            <AreaChart data={mockData}>
              <defs>
                <linearGradient id="colorPrice" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="hsl(189, 85%, 55%)" stopOpacity={0.3}/>
                  <stop offset="95%" stopColor="hsl(189, 85%, 55%)" stopOpacity={0}/>
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" stroke="hsl(217, 32%, 18%)" />
              <XAxis 
                dataKey="time" 
                stroke="hsl(215, 20%, 60%)"
                style={{ fontSize: '12px' }}
              />
              <YAxis 
                stroke="hsl(215, 20%, 60%)"
                style={{ fontSize: '12px' }}
                domain={['dataMin - 2', 'dataMax + 2']}
              />
              <Tooltip 
                contentStyle={{ 
                  backgroundColor: 'hsl(220, 40%, 8%)',
                  border: '1px solid hsl(217, 32%, 18%)',
                  borderRadius: '8px',
                  color: 'hsl(210, 40%, 98%)'
                }}
              />
              <Area 
                type="monotone" 
                dataKey="price" 
                stroke="hsl(189, 85%, 55%)" 
                strokeWidth={2}
                fill="url(#colorPrice)" 
              />
            </AreaChart>
          </ResponsiveContainer>
        </TabsContent>
        
        <TabsContent value="volume" className="mt-6">
          <ResponsiveContainer width="100%" height={350}>
            <LineChart data={mockData}>
              <CartesianGrid strokeDasharray="3 3" stroke="hsl(217, 32%, 18%)" />
              <XAxis 
                dataKey="time" 
                stroke="hsl(215, 20%, 60%)"
                style={{ fontSize: '12px' }}
              />
              <YAxis 
                stroke="hsl(215, 20%, 60%)"
                style={{ fontSize: '12px' }}
              />
              <Tooltip 
                contentStyle={{ 
                  backgroundColor: 'hsl(220, 40%, 8%)',
                  border: '1px solid hsl(217, 32%, 18%)',
                  borderRadius: '8px',
                  color: 'hsl(210, 40%, 98%)'
                }}
              />
              <Line 
                type="monotone" 
                dataKey="volume" 
                stroke="hsl(270, 70%, 60%)" 
                strokeWidth={2}
              />
            </LineChart>
          </ResponsiveContainer>
        </TabsContent>
      </Tabs>
    </Card>
  );
};
