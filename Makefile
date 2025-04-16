CURRENT_DATE := $(shell date +%Y-%m-%d_%H-%M)
BASE_DIR := $(shell realpath COV_OUT)/$(CURRENT_DATE)
DURATION := 24
CPUSTART := 20
NRUNS := 10
IMAGE := fgbasechecker-eval

# Script runs for 24 hours (hardcoded)
eval-srs:
	@for i in $$(seq 1 $(NRUNS)); do \
		echo "STARTING INSTANCE $$i FOR FUZZING"; \
		mkdir -p $(BASE_DIR)/$$i; \
		COVERAGE_OUT=$(BASE_DIR)/$$i \
		CORES="$$(( $$i + $(CPUSTART) ))" \
		docker compose run -d \
		--name=$(IMAGE)-$$i \
		-e INSTANCE=$$i \
		--rm \
		$(IMAGE) /app/do_SRS.sh; \
	done
