CURRENT_DATE := $(shell date +%Y-%m-%d_%H-%M)
BASE_DIR := $(shell realpath COV_OUT)/$(CURRENT_DATE)
DURATION := 24
CPUSTART := 5
NRUNS := 5
IMAGE := fgbasechecker-eval

# Script runs for 24 hours (hardcoded)
eval-srs:
	@for i in $$(seq 1 $(NRUNS)); do \
		echo "STARTING INSTANCE $$i FOR FUZZING"; \
		mkdir -p $(BASE_DIR)/$$i; \
		COVERAGE_OUT=$(BASE_DIR)/$$i \
		CORES="$$(( ($$i-1)*10 + $(CPUSTART) )),$$(( ($$i-1)*10 + $(CPUSTART) + 1 )),$$(( ($$i-1)*10 + $(CPUSTART) + 2 )),$$(( ($$i-1)*10 + $(CPUSTART) + 3 )),$$(( ($$i-1)*10 + $(CPUSTART) + 4 )),$$(( ($$i-1)*10 + $(CPUSTART) + 5 )),$$(( ($$i-1)*10 + $(CPUSTART) + 6 )),$$(( ($$i-1)*10 + $(CPUSTART) + 7 )),$$(( ($$i-1)*10 + $(CPUSTART) + 8 )),$$(( ($$i-1)*10 + $(CPUSTART) + 9 ))" \
		docker compose run -d \
		--name=$(IMAGE)-$$i \
		-e INSTANCE=$$i \
		--rm \
		$(IMAGE) sh -c "/app/do_SRS.sh > /data/coverage/log.txt 2>&1"; \
	done
