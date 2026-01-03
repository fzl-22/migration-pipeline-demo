MIGRATION_DIR ?= migrations

migrate-up:
ifdef STEPS
	@echo "Running migration UP by $(STEPS) steps..."
	migrate -path $(MIGRATION_DIR) -database $(DB_DSN) -verbose up $(STEPS)
else
	@echo "Running all pending migrations..."
	migrate -path $(MIGRATION_DIR) -database $(DB_DSN) -verbose up
endif

migrate-down:
ifndef STEPS
	$(error SAFETY CHECK FAILED: You must specify STEPS for down migrations.)
else
	@echo "Rolling back migration by $(STEPS) steps..."
	migrate -path $(MIGRATION_DIR) -database "$(DB_DSN)" -verbose down $(STEPS)
endif

.PHONY: migrate-up migrate-down