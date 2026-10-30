
version_forecast := 2

.SECONDARY:

figures := out/fig_direct_age_2016.pdf \
           out/fig_direct_age_2021.pdf \
           out/fig_direct_time.pdf \
           out/fig_heldback.pdf \
           out/fig_forecast_london_se.pdf \
           out/fig_forecast_se_london.pdf \
           out/fig_forecast_london_ne.pdf \
           out/fig_sensitivity_all_female.pdf \
           out/fig_sensitivity_all_male.pdf \
           out/fig_forecast_od_female.pdf \
           out/fig_forecast_od_male.pdf \
           out/fig_map_england.pdf

tables := out/tab_hyper_all.tex \
          out/tab_ppc_all.tex \
          out/tab_waic_all.tex \
          out/tab_resources_all.tex


.PHONY: all
all: $(figures) $(tables)


out/data.rds: src/data.R data/england-region-migration-2026-09-25.zip
	Rscript $^ $@

out/names_models.rds: src/names_models.R
	Rscript $^ $@

out/fig_direct_age_2016.pdf: src/fig_direct_age.R out/data.rds
	Rscript $^ $@ --year=2016

out/fig_direct_age_2021.pdf: src/fig_direct_age.R out/data.rds
	Rscript $^ $@ --year=2021

out/fig_direct_time.pdf: src/fig_direct_time.R out/data.rds
	Rscript $^ $@

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
  config.yaml \
  out/names_models.rds
	Rscript $^ $@

out/waic_%.rds: src/waic.R out/aug_%.rds out/disp_%.rds config.yaml
	Rscript $^ $@

out/tab_waic_all.tex: src/tab_waic_all.R \
  out/waic_naive.rds \
  out/waic_0.rds \
  out/waic_1.rds \
  out/waic_2.rds \
  out/names_models.rds
	Rscript $^ $@

out/resources_%.rds: src/resources.R out/mod_%.rds  config.yaml
	Rscript $^ $@

out/tab_resources_all.tex: src/tab_resources_all.R \
  out/resources_0.rds \
  out/resources_1.rds \
  out/resources_2.rds \
  out/names_models.rds
	Rscript $^ $@

out/hyper_%.rds: src/hyper.R out/fit_%.rds config.yaml
	Rscript $^ $@

out/tab_hyper_all.tex: src/tab_hyper_all.R \
  out/hyper_0.rds \
  out/hyper_1.rds \
  out/hyper_2.rds \
  config.yaml \
  out/names_models.rds
	Rscript $^ $@
  
out/forecast.rds: src/forecast.R out/fit_$(version_forecast).rds config.yaml
	Rscript $^ $@

out/vals_forecast.rds: src/vals_forecast.R  \
  out/fit_$(version_forecast).rds \
  out/aug_$(version_forecast).rds \
  config.yaml
	Rscript $^ $@

out/heldback_%_2020-2024.rds: src/heldback.R out/data.rds config.yaml
	Rscript $^ $@ --version=$* --heldback_forecast=2020-2024

out/heldback_%_2017-2019.rds: src/heldback.R out/data.rds config.yaml
	Rscript $^ $@ --version=$* --heldback_forecast=2017-2019

out/heldback_%_2022-2024.rds: src/heldback.R out/data.rds config.yaml
	Rscript $^ $@ --version=$* --heldback_forecast=2022-2024

out/vals_heldback_%_2020-2024.rds: src/vals_heldback.R \
  out/heldback_%_2020-2024.rds \
  config.yaml
	Rscript $^ $@

out/vals_heldback_%_2017-2019.rds: src/vals_heldback.R \
  out/heldback_%_2017-2019.rds \
  config.yaml
	Rscript $^ $@

out/vals_heldback_%_2022-2024.rds: src/vals_heldback.R \
  out/heldback_%_2022-2024.rds \
  config.yaml
	Rscript $^ $@

out/vals_heldback_all.rds: src/vals_heldback_all.R \
  out/vals_heldback_naive_2020-2024.rds \
  out/vals_heldback_0_2020-2024.rds \
  out/vals_heldback_1_2020-2024.rds \
  out/vals_heldback_2_2020-2024.rds \
  out/vals_heldback_naive_2017-2019.rds \
  out/vals_heldback_0_2017-2019.rds \
  out/vals_heldback_1_2017-2019.rds \
  out/vals_heldback_2_2017-2019.rds \
  out/vals_heldback_naive_2022-2024.rds \
  out/vals_heldback_0_2022-2024.rds \
  out/vals_heldback_1_2022-2024.rds \
  out/vals_heldback_2_2022-2024.rds \
  out/names_models.rds \
  config.yaml
	Rscript $^ $@

out/fig_heldback.pdf: src/fig_heldback.R \
  out/vals_heldback_all.rds \
  config.yaml
	Rscript $^ $@


out/fig_forecast_london_se.pdf: src/fig_forecast.R out/vals_forecast.rds
	Rscript $^ $@ --orig=London --dest="South East"

out/fig_forecast_se_london.pdf: src/fig_forecast.R out/vals_forecast.rds
	Rscript $^ $@ --orig="South East" --dest="London"

out/fig_forecast_london_ne.pdf: src/fig_forecast.R out/vals_forecast.rds
	Rscript $^ $@ --orig=London --dest="North East"

out/sensitivity_%.rds: src/sensitivity.R out/data.rds
	Rscript $^ $@ --val_s=$*

out/vals_sensitivity_%.rds: src/vals_sensitivity.R out/sensitivity_%.rds config.yaml
	Rscript $^ $@

out/vals_sensitivity_1.rds: src/vals_sensitivity.R out/fit_2.rds config.yaml
	Rscript $^ $@

out/fig_sensitivity_all_female.pdf: src/fig_sensitivity_all.R \
  out/vals_sensitivity_0.1.rds \
  out/vals_sensitivity_0.5.rds \
  out/vals_sensitivity_1.rds
	Rscript $^ $@ --sex=Female

out/fig_sensitivity_all_male.pdf: src/fig_sensitivity_all.R \
  out/vals_sensitivity_0.1.rds \
  out/vals_sensitivity_0.5.rds \
  out/vals_sensitivity_1.rds
	Rscript $^ $@ --sex=Male

out/fig_map_england.pdf: src/fig_map_england.R \
  data/Regions_December_2024_Boundaries_EN_BUC_1864665699622012197/RGN_DEC_24_EN_BUC.shp
	Rscript $^ $@

out/fig_forecast_od_female.pdf: src/fig_forecast_od.R out/vals_forecast.rds
	Rscript $^ $@ --sex="Female"

out/fig_forecast_od_male.pdf: src/fig_forecast_od.R out/vals_forecast.rds
	Rscript $^ $@ --sex="Male"


.PHONY: clean
clean:
	rm -rf out
	mkdir out

.PHONY: copy
copy: $(figures) $(tables)
	cp $(figures) ../british_migration/figures/
	cp $(tables) ../british_migration/tables/
