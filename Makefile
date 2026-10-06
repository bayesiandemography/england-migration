
version_forecast := 2

.SECONDARY:

.PHONY: all
all: out/fig_direct_age_2016.pdf \
     out/fig_direct_age_2021.pdf \
     out/tab_ppc_all.tex \
     out/tab_waic_all.tex \
     out/fig_forecast_london_se.pdf \
     out/fig_forecast_se_london.pdf \
     out/fig_forecast_london_ne.pdf


out/data.rds: src/data.R data/england-region-migration-2026-09-25.zip
	Rscript $^ $@

out/fig_direct_age_2016.pdf: src/fig_direct_age.R out/data.rds
	Rscript $^ $@ --year=2016

out/fig_direct_age_2021.pdf: src/fig_direct_age.R out/data.rds
	Rscript $^ $@ --year=2021

out/mod_%.rds: src/mod.R out/data.rds
	Rscript $^ $@ --version=$*

out/fit_%.rds: src/fit.R out/mod_%.rds config.yaml
	Rscript $^ $@

out/aug_%.rds: src/aug.R out/fit_%.rds config.yaml
	Rscript $^ $@

out/disp_%.rds: src/disp.R out/fit_%.rds config.yaml
	Rscript $^ $@

out/replicate_%.rds: src/replicate.R out/aug_%.rds out/disp_%.rds
	Rscript $^ $@

out/ppc_%.rds: src/ppc.R out/replicate_%.rds config.yaml
	Rscript $^ $@

out/tab_ppc_all.tex: src/tab_ppc_all.R \
  out/ppc_0.rds \
  out/ppc_1.rds \
  out/ppc_2.rds \
  config.yaml
	Rscript $^ $@

out/waic_%.rds: src/waic.R out/aug_%.rds config.yaml
	Rscript $^ $@

out/tab_waic_all.tex: src/tab_waic_all.R \
  out/waic_0.rds \
  out/waic_1.rds \
  out/waic_2.rds
	Rscript $^ $@

out/forecast.rds: src/forecast.R out/fit_$(version_forecast).rds config.yaml
	Rscript $^ $@

out/vals_forecast.rds: src/vals_forecast.R  \
  out/fit_$(version_forecast).rds \
  out/aug_$(version_forecast).rds \
  config.yaml
	Rscript $^ $@

out/heldback_%.rds: src/heldback.R out/data.rds config.yaml
	Rscript $^ $@ --version=$*

out/vals_heldback_%.rds: src/vals_heldback.R out/heldback_%.rds config.yaml
	Rscript $^ $@

out/vals_heldback_all.rds: src/vals_heldback_all.R \
  out/vals_heldback_naive.rds \
  out/vals_heldback_0.rds \
  out/vals_heldback_1.rds \
  out/vals_heldback_2.rds \
  config.yaml
	Rscript $^ $@

out/fig_heldback_all.pdf: src/fig_heldback_all.R out/vals_heldback_all.rds
	Rscript $^ $@

out/fig_forecast_london_se.pdf: src/fig_forecast.R out/vals_forecast.rds
	Rscript $^ $@ --orig=London --dest="South East"

out/fig_forecast_se_london.pdf: src/fig_forecast.R out/vals_forecast.rds
	Rscript $^ $@ --orig="South East" --dest="London"

out/fig_forecast_london_ne.pdf: src/fig_forecast.R out/vals_forecast.rds
	Rscript $^ $@ --orig=London --dest="North East"



.PHONY: clean
clean:
	rm -rf out
	mkdir out
