
.PHONY: all
all: out/replicate.rds

out/data.rds: src/data.R data/england-region-migration-2026-09-25.zip
	Rscript $^ $@

out/model.rds: src/model.R out/data.rds
	Rscript $^ $@

out/fit.rds: src/fit.R out/model.rds config.yaml
	Rscript $^ $@

out/aug.rds: src/aug.R out/fit.rds config.yaml
	Rscript $^ $@

out/disp.rds: src/disp.R out/fit.rds config.yaml
	Rscript $^ $@

out/replicate.rds: src/replicate.R out/aug.rds out/disp.rds
	Rscript $^ $@


.PHONY: clean
clean:
	rm -rf out
	mkdir out


