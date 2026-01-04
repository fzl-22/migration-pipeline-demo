MIGRATION_DIR ?= migrations

DATABASE_DSN=postgresql://$(DB_DEMO_MASTER_USER):$(DB_DEMO_MASTER_PASSWORD)@$(DB_DEMO_MASTER_HOST):$(DB_DEMO_MASTER_PORT)/$(DB_DEMO_MASTER_NAME)?sslmode=$(DB_DEMO_MASTER_SSLMODE)

migrate-up:
	@if [ -n "$(STEPS)" ]; then \
		echo "Running migration UP by $(STEPS) steps..."; \
		migrate -path $(MIGRATION_DIR) -database $(DATABASE_DSN) -verbose up $(STEPS); \
	else \
		echo "Running all pending migrations..."; \
		migrate -path $(MIGRATION_DIR) -database $(DATABASE_DSN) -verbose up; \
	fi


migrate-down:
	@if [ -n "$(STEPS)" ]; then \
		echo "Rolling back migration by $(STEPS) steps..."; \
		migrate -path $(MIGRATION_DIR) -database $(DATABASE_DSN) -verbose down $(STEPS); \
	elif [ "$(ALL)" == "true" ]; then \
		echo "Rolling back ALL migrations..."; \
		migrate -path $(MIGRATION_DIR) -database $(DATABASE_DSN) -verbose down -all; \
	else \
		echo "SAFETY CHECK FAILED: You must specify STEPS (e.g., STEPS=1) or ALL=true for down migrations." >&2; \
		exit 1; \
	fi

.PHONY: migrate-up migrate-down