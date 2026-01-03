MIGRATION_DIR ?= migrations

DATABASE_DSN=postgresql://$(DB_DEMO_MASTER_USER):$(DB_DEMO_MASTER_PASSWORD)@$(DB_DEMO_MASTER_HOST):$(DB_DEMO_MASTER_PORT)/$(DB_DEMO_MASTER_NAME)

migrate-up:
ifdef STEPS
	@echo "Running migration UP by $(STEPS) steps..."
	migrate -path $(MIGRATION_DIR) -database $(DATABASE_DSN) -verbose up $(STEPS)
else
	@echo "Running all pending migrations..."
	migrate -path $(MIGRATION_DIR) -database $(DATABASE_DSN) -verbose up
endif

migrate-down:
ifndef STEPS
	$(error SAFETY CHECK FAILED: You must specify STEPS for down migrations.)
else
	@echo "Rolling back migration by $(STEPS) steps..."
	migrate -path $(MIGRATION_DIR) -database "$(DATABASE_DSN)" -verbose down $(STEPS)
endif

.PHONY: migrate-up migrate-down