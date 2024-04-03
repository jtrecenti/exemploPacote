
baixar_iffhs_bruto <- function() {
  tabelas <- httr::GET("https://en.wikipedia.org/wiki/List_of_footballers_with_500_or_more_goals") |>
    httr::content() |>
    rvest::html_table()
  tabelas
}

#' Baixa e limpa o ranking de artilheiros da IFFHS
#'
#' Esta função baixa o ranking de artilheiros da IFFHS e limpa os dados.
#'
#' @param ano_inicio_carreira Ano de início da carreira do jogador
#'
#' @return Um tibble com o ranking de artilheiros da IFFHS
#'
#' @export
baixar_iffhs <- function(ano_inicio_carreira = 1900) {

  iffhs <- baixar_iffhs_bruto() |>
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
    ) |>
    dplyr::mutate(
      ano_inicio = stringr::str_extract(career_span, "[0-9]+"),
      ano_inicio = as.numeric(ano_inicio)
    ) |>
    dplyr::filter(
      ano_inicio >= ano_inicio_carreira
    )

  iffhs
}


