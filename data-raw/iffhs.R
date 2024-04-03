## code to prepare `iffhs` dataset goes here


library(httr)

tabelas <- GET("https://en.wikipedia.org/wiki/List_of_footballers_with_500_or_more_goals") |>
  content() |>
  rvest::html_table()

iffhs <- tabelas |>
  purrr::pluck(2) |>
  janitor::row_to_names(1) |>
  janitor::clean_names() |>
  dplyr::select(
    rank, player, league, cup, continental,
    country = dplyr::starts_with("mw"),
    total, career_span
  ) |>
  dplyr::mutate(
    player = stringr::str_remove(player, "\\*"),
    dplyr::across(
      c(league, cup, continental, country, total),
      readr::parse_number
    )
  )

# xml2
# rvest

usethis::use_data(iffhs, overwrite = TRUE)
