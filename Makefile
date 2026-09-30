.SECONDARY:

.PHONY: all
all: out/tab_ppc_all.tex

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

out/ppc%.rds: src/ppc.R out/replicate%.rds config.yaml
	Rscript $^ $@

out/tab_ppc_all.tex: src/tab_ppc_all.R out/ppc0.rds out/ppc1.rds out/ppc2.rds config.yaml
	Rscript $^ $@


.PHONY: clean
clean:
	rm -rf out
	mkdir out
