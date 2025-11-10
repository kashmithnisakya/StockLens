import { useState, useEffect } from "react";
import { Card } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Bot, Send, User, Loader2 } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { useStockAnalysisContext } from "@/contexts/StockAnalysisContext";
import { chatService } from "@/services/chat.service";
import { useToast } from "@/hooks/use-toast";

interface Message {
  role: "user" | "assistant";
  content: string;
}

const INITIAL_MESSAGE: Message = {
  role: "assistant",
  content: "Hello! I'm your AI stock market analyst. Ask me anything about stocks, market trends, or investment strategies. I can help you analyze any ticker in real-time."
};

export const AIChat = () => {
  const { resultId, ticker } = useStockAnalysisContext();
  const { toast } = useToast();
  const [messages, setMessages] = useState<Message[]>([INITIAL_MESSAGE]);
  const [input, setInput] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  // Reset chat when a new stock is analyzed
  useEffect(() => {
    if (resultId && ticker) {
      setMessages([
        INITIAL_MESSAGE,
        {
          role: "assistant",
          content: `I've completed the analysis for ${ticker}. Feel free to ask me any questions about this stock!`
        }
      ]);
    }
  }, [resultId, ticker]);

  const handleSend = async () => {
    if (!input.trim()) return;

    // Check if we have a result_id from a stock analysis
    if (!resultId) {
      toast({
        title: "Analysis Required",
        description: "Please analyze a stock first before chatting about it.",
        variant: "destructive",
      });
      return;
    }

    // Add user message
    const userMessage = input;
    const newMessages: Message[] = [
      ...messages,
      { role: "user", content: userMessage }
    ];
    setMessages(newMessages);
    setInput("");
    setIsLoading(true);

    try {
      // Call the chat API
      const response = await chatService.sendMessage(resultId, userMessage);

      if (response.reports && response.reports.length > 0) {
        const aiResponse = response.reports[0].answer;
        setMessages([
          ...newMessages,
          {
            role: "assistant",
            content: aiResponse
          }
        ]);
      } else {
        throw new Error("No response received");
      }
    } catch (error: any) {
      toast({
        title: "Chat Error",
        description: error.message || "Failed to get response from AI",
        variant: "destructive",
      });

      // Add error message to chat
      setMessages([
        ...newMessages,
        {
          role: "assistant",
          content: "I'm sorry, I encountered an error processing your question. Please try again."
        }
      ]);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <Card className="flex h-full flex-col bg-card/60 backdrop-blur-glass border-border/50">
      <div className="border-b border-border/50 p-4">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-accent">
              <Bot className="h-5 w-5 text-accent-foreground" />
            </div>
            <div>
              <h3 className="font-semibold">AI Market Analyst</h3>
              <p className="text-xs text-muted-foreground">Multi-Agent System</p>
            </div>
          </div>
          <Badge
            variant="secondary"
            className={
              resultId
                ? "bg-green-500/20 text-green-600"
                : "bg-yellow-500/20 text-yellow-600"
            }
          >
            {resultId ? "Ready" : "Waiting"}
          </Badge>
        </div>
      </div>

      <ScrollArea className="flex-1 p-4 custom-scrollbar">
        <div className="space-y-4">
          {messages.map((message, index) => (
            <div
              key={index}
              className={`flex gap-3 ${message.role === "user" ? "justify-end" : "justify-start"}`}
            >
              {message.role === "assistant" && (
                <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-lg bg-accent">
                  <Bot className="h-5 w-5 text-accent-foreground" />
                </div>
              )}
              <div
                className={`max-w-[80%] rounded-lg p-3 ${
                  message.role === "user"
                    ? "bg-primary text-primary-foreground"
                    : "bg-secondary"
                }`}
              >
                <p className="text-sm">{message.content}</p>
              </div>
              {message.role === "user" && (
                <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-lg bg-primary">
                  <User className="h-5 w-5 text-primary-foreground" />
                </div>
              )}
            </div>
          ))}
        </div>
      </ScrollArea>

      <div className="border-t border-border/50 p-4">
        <div className="flex gap-2">
          <Input
            value={input}
            onChange={(e) => setInput(e.target.value)}
            onKeyDown={(e) => e.key === "Enter" && !isLoading && handleSend()}
            placeholder={resultId ? "Ask about stocks, trends, or analysis..." : "Analyze a stock first..."}
            className="bg-secondary border-border/50"
            disabled={isLoading || !resultId}
          />
          <Button
            onClick={handleSend}
            variant="hero"
            size="icon"
            disabled={isLoading || !resultId || !input.trim()}
          >
            {isLoading ? (
              <Loader2 className="h-4 w-4 animate-spin" />
            ) : (
              <Send className="h-4 w-4" />
            )}
          </Button>
        </div>
      </div>
    </Card>
  );
};
