// Chat API Service
import { apiClient } from "./api-client";
import type { ChatRequest, ChatResponse } from "../types/api";

class ChatService {
  /**
   * Send a chat message and get AI response
   * @param resultId - The result ID from the stock analysis
   * @param query - The user's question
   * @returns Chat response with answer and chat history
   */
  async sendMessage(resultId: string, query: string): Promise<ChatResponse> {
    const payload: ChatRequest = {
      result_id: resultId,
      quary: query, // Note: API uses "quary" (typo in backend)
    };

    return await apiClient.post<ChatRequest, ChatResponse>(
      "/walker/chat",
      payload
    );
  }
}

export const chatService = new ChatService();
