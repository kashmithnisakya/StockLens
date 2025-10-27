import from datetime { datetime }
import from typing { Dict, List, Any }
import from nodes {
    master_agent, stock_analyst, investment_strategist,
    market_researcher, Status, AnalysisDepth, agents
}
import from fastapi { HTTPException, status }
import from jac_cloud.jaseci.utils.logger { logger }
import from ai_core { AgentRole }


# Walker to initialize the analysis system
walker init_analysis {
    has ticker: str;
    has depth: AnalysisDepth = AnalysisDepth.QUICK;

    class __specs__ {
        has tags: list = ["stock"];
        has auth: bool = False;
    }

    can init_master with `root entry {
        visit [-->](`?master_agent) else {
            logger.debug("agent_orchestrator | init_analysis | Creating master agent node");
            master_node = here ++> master_agent();
            visit master_node;
        };
    } 

    can init_system with master_agent entry {
        # Set up master agent
        here.ticker = self.ticker;
        here.status = Status.IN_PROGRESS;
        here.depth = self.depth;

        # Create agent nodes
        if not [-->](`?market_researcher) {
            logger.debug("agent_orchestrator | init_analysis | Creating Market Researcher agent node");
            here ++> market_researcher(
                ticker=self.ticker
            );
        } 
        if not [-->](`?stock_analyst) {
            logger.debug("agent_orchestrator | init_analysis | Creating Stock Analyst agent node");
            here ++> stock_analyst();
        } 
        if not [-->](`?investment_strategist) {
            logger.debug("agent_orchestrator | init_analysis | Creating Investment Strategist agent node");
            here ++> investment_strategist();
        }

        if here.depth.value == AnalysisDepth.QUICK.value {
            logger.debug("agent_orchestrator | init_analysis | Quick analysis selected");
            here.sequence = [AgentRole.MARKET_RESEARCHER.value, AgentRole.STOCK_ANALYST.value, AgentRole.INVESTMENT_STRATEGIST.value];
        } elif here.depth.value == AnalysisDepth.STANDARD.value {
            logger.debug("agent_orchestrator | init_analysis | Standard analysis selected");
            logger.debug("Not implemented yet(visit_by is not ready yet)");
        } else {
            logger.debug("agent_orchestrator | init_analysis | Comprehensive analysis selected");
            here.sequence = here.execute(walker_obj=self);
        }
    }
}

walker orchestrator {
    has ticker: str;
    has depth: AnalysisDepth = AnalysisDepth.QUICK;
    has result: Dict[str, Any] = {};
    has knowledge_base: list = [];

    class __specs__ {
        has tags: list = ["stock"];
        has auth: bool = False;
    }

    can start_orchestration with `root entry {
        logger.debug(f"agent_orchestrator | orchestrate_analysis | orchestration start for {self.ticker} at depth {self.depth}");
        here spawn init_analysis(ticker=self.ticker, depth=self.depth);
        visit [-->](`?master_agent) else {
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Master agent node not found after initialization."
            );
        };
    }

    can run_orchestration with master_agent entry {
        logger.debug(f"agent_orchestrator | orchestrate_analysis | running orchestration for {self.ticker}");
        agent_queue = here.sequence.copy();
        execution_sequence = [];
        while len(agent_queue) > 0 and here.max_executions > len(execution_sequence) {
            current_agent = agent_queue.pop(0);
            logger.debug(f"agent_orchestrator | orchestrate_analysis | executing agent: {current_agent}");
            execution_sequence.append(current_agent);
            agent_node = [-->] (`?agents[current_agent]);
            agent_result = agent_node[0].execute(walker_obj=self);
            logger.debug(f"agent_orchestrator | orchestrate_analysis | agent {current_agent} returned: {agent_result}");
            self.knowledge_base.append({
                "agent": current_agent,
                "result": agent_result,
                "timestamp": datetime.now().isoformat()
            });

            if current_agent == AgentRole.STOCK_ANALYST.value and self.depth.value == AnalysisDepth.COMPREHENSIVE.value {
                redo_research = agent_result.redo_research;
                if redo_research {
                    logger.debug(f"agent_orchestrator | orchestrate_analysis | redoing research as per Stock Analyst recommendation");
                    updated_sequence = here.execute(walker_obj=self);
                    # update agent_queue to according to new queue
                    agent_queue = updated_sequence.copy();
                    logger.debug(f"agent_orchestrator | orchestrate_analysis | updated agent queue: {agent_queue}");
                } else {
                    logger.debug(f"agent_orchestrator | orchestrate_analysis | no need to redo research");
                }
            }
        }
        if len(execution_sequence) == here.max_executions {
            logger.warning(f"agent_orchestrator | orchestrate_analysis | reached maximum execution limit of {self.max_executions} agents");
            agent_result = investment_strategist.execute(walker_obj=self);
            self.knowledge_base.append({
                "agent": AgentRole.INVESTMENT_STRATEGIST.value,
                "result": agent_result,
                "timestamp": datetime.now().isoformat()
            });
        }

        report self.knowledge_base[-1]["result"];
    }
}