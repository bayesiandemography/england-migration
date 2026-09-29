versions := 0 1 2

replicates := $(foreach v,$(versions),out/replicate$(v).rds)

.SECONDARY:

.PHONY: all
all: $(replicates)

out/data.rds: src/data.R data/england-region-migration-2026-09-25.zip
	Rscript $^ $@

out/mod%.rds: src/mod.R out/data.rds
	Rscript $^ $@ --version=$*

out/fit%.rds: src/fit.R out/mod%.rds config.yaml
	Rscript $^ $@

out/aug%.rds: src/aug.R out/fit%.rds config.yaml
	Rscript $^ $@

out/disp%.rds: src/disp.R out/fit%.rds config.yaml
	Rscript $^ $@

out/replicate%.rds: src/replicate.R out/aug%.rds out/disp%.rds
	Rscript $^ $@


.PHONY: clean
clean:
	rm -rf out
	mkdir out
