class StateManager:
    def __init__(self, agent_id):
        self.agent_id = agent_id
        self.state = {}

    def update_state(self, key, value):
        self.state[key] = value
        self._persist()

    def _persist(self):
        # Simplified persistence
        with open(f"{self.agent_id}_state.json", 'w') as f:
            json.dump(self.state, f)