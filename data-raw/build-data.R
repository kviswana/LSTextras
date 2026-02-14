# data-raw/build-data.R
library(readr)
library(tibble)

# Example: load CSV -> tibble -> save into package data/
acct_type_balance <- readr::read_csv("data-raw/acct_type_balance.csv", show_col_types = FALSE) |>
  tibble::as_tibble()

advertising_sales_channel <- readr::read_csv("data-raw/advertising_sales_channel.csv", show_col_types = FALSE) |>
  tibble::as_tibble()

age_income_gender_buy <- readr::read_csv("data-raw/age_income_gender_buy.csv", show_col_types = FALSE) |>
  tibble::as_tibble()

age_income_gender_buy <- age_income_gender_buy |> select(-1)

BostonHousing <- readr::read_csv("data-raw/BostonHousing.csv", show_col_types = FALSE) |>
  tibble::as_tibble()

demand_expenditure_simpson <- readr::read_csv("data-raw/demand_expenditure_simpson.csv", show_col_types = FALSE) |>
  tibble::as_tibble()

employees <- readr::read_csv("data-raw/employees.csv", show_col_types = FALSE) |>
  tibble::as_tibble()

exp_demand <- readr::read_csv("data-raw/exp_demand.csv", show_col_types = FALSE) |>
  tibble::as_tibble()

homes <- readr::read_csv("data-raw/homes.csv", show_col_types = FALSE) |>
  tibble::as_tibble()

ice_cream_paradox <- readr::read_csv("data-raw/ice_cream_paradox.csv", show_col_types = FALSE) |>
  tibble::as_tibble()

movies <- readr::read_csv("data-raw/movies.csv", show_col_types = FALSE) |>
  tibble::as_tibble()

price_demand <- readr::read_csv("data-raw/price_demand.csv", show_col_types = FALSE) |>
  tibble::as_tibble()

production_cost <- readr::read_csv("data-raw/production_cost.csv", show_col_types = FALSE) |>
  tibble::as_tibble()

returns_dpo <- readr::read_csv("data-raw/returns_dpo.csv", show_col_types = FALSE) |>
  tibble::as_tibble()

sales_advertising <- readr::read_csv("data-raw/sales_advertising.csv", show_col_types = FALSE) |>
  tibble::as_tibble()

sales <- readr::read_csv("data-raw/sales.csv", show_col_types = FALSE) |>
  tibble::as_tibble()

sales <- sales |> select(-1)

variance_example <- readr::read_csv("data-raw/variance_example.csv", show_col_types = FALSE) |>
  tibble::as_tibble()

kiosk <- readr::read_csv("data-raw/kiosk.csv", show_col_types = FALSE) |>
  tibble::as_tibble()

kiosk_mall_beach <- readr::read_csv("data-raw/kiosk_mall_beach.csv", show_col_types = FALSE) |>
  tibble::as_tibble()

kiosk_beach_mall_temp <- readr::read_csv("data-raw/kiosk_beach_mall_temp.csv", show_col_types = FALSE) |>
  tibble::as_tibble()




# Save as .rda files in data/
usethis::use_data(acct_type_balance, advertising_sales_channel, age_income_gender_buy,
                  BostonHousing, demand_expenditure_simpson, employees, exp_demand,
                  homes, ice_cream_paradox, movies, price_demand, production_cost,
                  returns_dpo, sales_advertising, sales, variance_example, kiosk,
                  kiosk_mall_beach, kiosk_beach_mall_temp,
                  overwrite = TRUE)




