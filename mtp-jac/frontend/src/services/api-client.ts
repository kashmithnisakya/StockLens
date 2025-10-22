// API Client Configuration
import type { ApiError } from "../types/api";

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || "http://localhost:8000";
const API_TIMEOUT = parseInt(import.meta.env.VITE_API_TIMEOUT || "30000");

class ApiClient {
  private baseUrl: string;
  private timeout: number;

  constructor(baseUrl: string = API_BASE_URL, timeout: number = API_TIMEOUT) {
    this.baseUrl = baseUrl;
    this.timeout = timeout;
  }

  private async fetchWithTimeout(
    url: string,
    options: RequestInit = {}
  ): Promise<Response> {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), this.timeout);

    try {
      const response = await fetch(url, {
        ...options,
        signal: controller.signal,
        headers: {
          "Content-Type": "application/json",
          ...options.headers,
        },
      });

      clearTimeout(timeoutId);
      return response;
    } catch (error) {
      clearTimeout(timeoutId);
      throw error;
    }
  }

  async post<TRequest, TResponse>(
    endpoint: string,
    data: TRequest
  ): Promise<TResponse> {
    try {
      const url = `${this.baseUrl}${endpoint}`;
      const response = await this.fetchWithTimeout(url, {
        method: "POST",
        body: JSON.stringify(data),
      });

      if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        const error: ApiError = {
          message: errorData.message || `HTTP error! status: ${response.status}`,
          status: response.status,
          details: errorData,
        };
        throw error;
      }

      return await response.json();
    } catch (error: any) {
      if (error.name === "AbortError") {
        const timeoutError: ApiError = {
          message: "Request timeout",
          details: error,
        };
        throw timeoutError;
      }
      throw error;
    }
  }

  async get<TResponse>(endpoint: string): Promise<TResponse> {
    try {
      const url = `${this.baseUrl}${endpoint}`;
      const response = await this.fetchWithTimeout(url, {
        method: "GET",
      });

      if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        const error: ApiError = {
          message: errorData.message || `HTTP error! status: ${response.status}`,
          status: response.status,
          details: errorData,
        };
        throw error;
      }

      return await response.json();
    } catch (error: any) {
      if (error.name === "AbortError") {
        const timeoutError: ApiError = {
          message: "Request timeout",
          details: error,
        };
        throw timeoutError;
      }
      throw error;
    }
  }
}

export const apiClient = new ApiClient();
