COMPOSE = docker compose
CAST    = $(COMPOSE) exec anvil cast
N ?= 1

.PHONY: up down logs reset chain-info chain-automine-off chain-automine-on chain-mine

up: ## Sobe o ambiente
	$(COMPOSE) up -d --wait

down: ## Derruba o ambiente
	$(COMPOSE) down

logs: ## Acompanha os logs
	$(COMPOSE) logs -f

reset: ## Derruba e apaga volumes (blockchain volta ao bloco 0)
	$(COMPOSE) down -v

chain-info: ## Mostra chain ID, bloco atual e saldo da conta 0
	@echo "chain id: $$($(CAST) chain-id)"
	@echo "bloco:    $$($(CAST) block-number)"
	@echo "saldo #0: $$($(CAST) balance 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 --ether) ETH"

chain-automine-off: ## Mineração manual: transações ficam pendentes
	$(CAST) rpc evm_setAutomine false

chain-automine-on: ## Volta a minerar um bloco por transação
	$(CAST) rpc evm_setAutomine true

chain-mine: ## Minera N blocos (ex.: make chain-mine N=6)
	$(CAST) rpc anvil_mine $$(printf '0x%x' $(N))
