import from os { getenv }
import from typing { Dict, List, Any }
import from jac_cloud.jaseci.utils.logger { logger }
import from requests { post }


obj SerperConfig {
    has api_key: str = "";
    has base_url: str = "https://google.serper.dev";
    has search_endpoint: str = "/search";
    has news_endpoint: str = "/news";

    def postinit() {
        self.api_key = getenv("SERPER_API_KEY", "");
        if not self.api_key {
            logger.warning("serper_client | SerperConfig | SERPER_API_KEY not found in environment variables");
        }
    }
}

obj SerperClient {
    has config: SerperConfig;

    def search_stock_news(ticker: str, num_results: int = 10) -> Dict[str, Any] {
        if not self.config.api_key {
            logger.error("serper_client |  search_stock_news | SERPER API key not configured");
            return {
                "status": "error",
                "message": "SERPER API key not configured",
                "news": []
            };
        }

        try {
            url = f"{self.config.base_url}{self.config.news_endpoint}";
            headers = {
                "X-API-KEY": self.config.api_key,
                "Content-Type": "application/json"
            };
            payload = {
                "q": f"{ticker} stock news",
                "num": num_results,
                "tbs": "qdr:w"  # Last week
            };

            logger.debug(f"serper_client | search_stock_news | Searching news for {ticker}");
            response = post(url, json=payload, headers=headers, timeout=10);

            if response.status_code == 200 {
                data = response.json();
                news_items = [];

                if "news" in data {
                    for item in data["news"] {
                        news_items.append({
                            "title": item.get("title", ""),
                            "link": item.get("link", ""),
                            "snippet": item.get("snippet", ""),
                            "date": item.get("date", ""),
                            "source": item.get("source", "")
                        });
                    }
                }

                return {
                    "status": "success",
                    "news": news_items,
                    "count": len(news_items)
                };
            } else {
                logger.error(f"serper_client | search_stock_news | API error: {response.status_code}");
                return {
                    "status": "error",
                    "message": f"API returned status code {response.status_code}",
                    "news": []
                };
            }
        } except Exception as e {
            logger.error(f"serper_client | search_stock_news | Exception: {str(e)}");
            return {
                "status": "error",
                "message": str(e),
                "news": []
            };
        }
    }

    def search_market_trends(ticker: str, num_results: int = 5) -> Dict[str, Any] {
        if not self.config.api_key {
            logger.error("serper_client | search_market_trends | SERPER API key not configured");
            return {
                "status": "error",
                "message": "SERPER API key not configured",
                "trends": []
            };
        }

        try {
            url = f"{self.config.base_url}{self.config.search_endpoint}";
            headers = {
                "X-API-KEY": self.config.api_key,
                "Content-Type": "application/json"
            };
            payload = {
                "q": f"{ticker} stock market analysis trends",
                "num": num_results
            };

            logger.debug(f"serper_client | search_market_trends | Searching trends for {ticker}");
            response = post(url, json=payload, headers=headers, timeout=10);

            if response.status_code == 200 {
                data = response.json();
                trends = [];

                if "organic" in data {
                    for item in data["organic"] {
                        trends.append({
                            "title": item.get("title", ""),
                            "link": item.get("link", ""),
                            "snippet": item.get("snippet", "")
                        });
                    }
                }

                return {
                    "status": "success",
                    "trends": trends,
                    "count": len(trends)
                };
            } else {
                logger.error(f"serper_client | search_market_trends | API error: {response.status_code}");
                return {
                    "status": "error",
                    "message": f"API returned status code {response.status_code}",
                    "trends": []
                };
            }
        } except Exception as e {
            logger.error(f"serper_client | search_market_trends | Exception: {str(e)}");
            return {
                "status": "error",
                "message": str(e),
                "trends": []
            };
        }
    }

    def search_competitor_info(ticker: str, industry: str = "", num_results: int = 5) -> Dict[str, Any] {
        if not self.config.api_key {
            logger.error("serper_client | search_competitor_info | SERPER API key not configured");
            return {
                "status": "error",
                "message": "SERPER API key not configured",
                "competitors": []
            };
        }

        try {
            url = f"{self.config.base_url}{self.config.search_endpoint}";
            headers = {
                "X-API-KEY": self.config.api_key,
                "Content-Type": "application/json"
            };

            query = f"{ticker} competitors {industry}" if industry else f"{ticker} competitors";
            payload = {
                "q": query,
                "num": num_results
            };

            logger.debug(f"serper_client | search_competitor_info | Searching competitors for {ticker}");
            response = post(url, json=payload, headers=headers, timeout=10);

            if response.status_code == 200 {
                data = response.json();
                competitors = [];

                if "organic" in data {
                    for item in data["organic"] {
                        competitors.append({
                            "title": item.get("title", ""),
                            "link": item.get("link", ""),
                            "snippet": item.get("snippet", "")
                        });
                    }
                }

                return {
                    "status": "success",
                    "competitors": competitors,
                    "count": len(competitors)
                };
            } else {
                logger.error(f"serper_client | search_competitor_info | API error: {response.status_code}");
                return {
                    "status": "error",
                    "message": f"API returned status code {response.status_code}",
                    "competitors": []
                };
            }
        } except Exception as e {
            logger.error(f"serper_client | search_competitor_info | Exception: {str(e)}");
            return {
                "status": "error",
                "message": str(e),
                "competitors": []
            };
        }
    }

    def custom_search(query: str, num_results: int = 15, search_type: str = "search") -> Dict[str, Any] {
        if not self.config.api_key {
            logger.error("serper_client | custom_search | SERPER API key not configured");
            return {
                "status": "error",
                "message": "SERPER API key not configured",
                "results": []
            };
        }

        try {
            endpoint = self.config.news_endpoint if search_type == "news" else self.config.search_endpoint;
            url = f"{self.config.base_url}{endpoint}";
            headers = {
                "X-API-KEY": self.config.api_key,
                "Content-Type": "application/json"
            };
            payload = {
                "q": query,
                "num": num_results
            };

            if search_type == "news" {
                payload["tbs"] = "qdr:m";  # Last month for deeper research
            }

            logger.debug(f"serper_client | custom_search | Performing custom {search_type} search: {query}");
            response = post(url, json=payload, headers=headers, timeout=10);

            if response.status_code == 200 {
                data = response.json();
                results = [];

                if search_type == "news" and "news" in data {
                    for item in data["news"] {
                        results.append({
                            "title": item.get("title", ""),
                            "link": item.get("link", ""),
                            "snippet": item.get("snippet", ""),
                            "date": item.get("date", ""),
                            "source": item.get("source", "")
                        });
                    }
                } elif "organic" in data {
                    for item in data["organic"] {
                        results.append({
                            "title": item.get("title", ""),
                            "link": item.get("link", ""),
                            "snippet": item.get("snippet", "")
                        });
                    }
                }

                return {
                    "status": "success",
                    "results": results,
                    "count": len(results),
                    "search_type": search_type
                };
            } else {
                logger.error(f"serper_client | custom_search | API error: {response.status_code}");
                return {
                    "status": "error",
                    "message": f"API returned status code {response.status_code}",
                    "results": []
                };
            }
        } except Exception as e {
            logger.error(f"serper_client | custom_search | Exception: {str(e)}");
            return {
                "status": "error",
                "message": str(e),
                "results": []
            };
        }
    }
}

glob serper_client = SerperClient(
    config=SerperConfig()
);
