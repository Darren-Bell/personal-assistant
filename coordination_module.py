class AgentCoordinator:
    def __init__(self):
        self.agents = {}

    def register_agent(self, agent_id, capabilities):
        self.agents[agent_id] = {
            'status': 'active',
            'capabilities': capabilities
        }

    def dispatch_task(self, agent_id, task):
        if agent_id in self.agents:
            return f"Task dispatched to {agent_id}"
        return "Agent not found"