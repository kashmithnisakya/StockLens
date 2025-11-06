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
            here ++> market_researcher();
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
        redo_research_mode = False;
        redo_count = 0;

        while len(agent_queue) > 0 and here.max_executions > len(execution_sequence) {
            current_agent = agent_queue.pop(0);
            logger.debug(f"agent_orchestrator | orchestrate_analysis | executing agent: {current_agent} (redo_mode: {redo_research_mode})");
            execution_sequence.append(current_agent);

            # Get agent node
            agent_node = [-->] (`?agents[current_agent]);

            # Execute agent with appropriate parameters
            if current_agent == AgentRole.MARKET_RESEARCHER.value {
                # Pass redo_research flag to market_researcher
                agent_result = agent_node[0].execute(walker_obj=self, redo_research=redo_research_mode);
                logger.debug(f"agent_orchestrator | orchestrate_analysis | Market Researcher executed with redo_research={redo_research_mode}");
                # Reset redo_research_mode after market researcher execution
                redo_research_mode = False;
            } else {
                agent_result = agent_node[0].execute(walker_obj=self);
            }

            logger.debug(f"agent_orchestrator | orchestrate_analysis | agent {current_agent} completed");
            logger.debug(f"agent_orchestrator | orchestrate_analysis | agent result: {agent_result}");
            self.knowledge_base.append({
                "agent": current_agent,
                "result": agent_result,
                "timestamp": datetime.now().isoformat()
            });

            # Check if Stock Analyst recommends redoing research
            if current_agent == AgentRole.STOCK_ANALYST.value and self.depth.value == AnalysisDepth.COMPREHENSIVE.value {
                redo_research = agent_result.redo_research;
                if redo_research and redo_count < 2 {
                    redo_count += 1;
                    logger.debug(f"agent_orchestrator | orchestrate_analysis | Stock Analyst requested redo_research (attempt {redo_count}/2)");
                    logger.debug(f"agent_orchestrator | orchestrate_analysis | Generating updated agent sequence");

                    # Set redo_research mode for next market_researcher execution
                    redo_research_mode = True;

                    # Generate updated sequence with context
                    updated_sequence = here.execute(walker_obj=self, redo_research=True);

                    # Update agent_queue with new sequence
                    agent_queue = updated_sequence.copy();
                    logger.debug(f"agent_orchestrator | orchestrate_analysis | Updated agent queue: {agent_queue}");
                } elif redo_research and redo_count >= 2 {
                    logger.warning(f"agent_orchestrator | orchestrate_analysis | Maximum redo_research attempts reached (2), continuing with current data");
                } else {
                    logger.debug(f"agent_orchestrator | orchestrate_analysis | Analysis sufficient, no redo needed");
                }
            }
        }

        # Safety check: ensure we have results
        if len(execution_sequence) == here.max_executions {
            logger.warning(f"agent_orchestrator | orchestrate_analysis | Reached maximum execution limit of {here.max_executions} agents");
            # Force execution of investment strategist if not in sequence
            if AgentRole.INVESTMENT_STRATEGIST.value not in execution_sequence {
                logger.debug(f"agent_orchestrator | orchestrate_analysis | Forcing Investment Strategist execution");
                strategist_node = [-->] (`?agents[AgentRole.INVESTMENT_STRATEGIST.value]);
                agent_result = strategist_node[0].execute(walker_obj=self);
                self.knowledge_base.append({
                    "agent": AgentRole.INVESTMENT_STRATEGIST.value,
                    "result": agent_result,
                    "timestamp": datetime.now().isoformat()
                });
            }
        }

        logger.debug(f"agent_orchestrator | orchestrate_analysis | Orchestration completed. Total agents executed: {len(execution_sequence)}");
        report self.knowledge_base[-1]["result"];
    }
}