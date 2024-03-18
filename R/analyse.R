#' Extract top n terms with the highest count across all topics
#'
#' @param data LDA model.
#' @param top_n The number of top words to be returned by the function.
#' @param topic_col Name of the column containing topics.
#' @param beta_col Name of the column containing the beta statistic for all terms.
#'
#' @return A data frame with the top n terms across all topics.
#' @export
get_top_words_per_topic <- function(data,
                                    top_n,
                                    topic_col = "topic",
                                    beta_col = "beta",
                                    topic_names = NULL) {
  
  # Extract data frame with topics, terms and beta statistic from LDA model
  topics <- tidytext::tidy(data, matrix = "beta")
  
  topic <- rlang::sym(topic_col)
  beta <- rlang::sym(beta_col)
  
  data_top_terms <- topics |>
    dplyr::group_by(!!topic) |>
    dplyr::top_n(top_n,!!beta) |>
    dplyr::ungroup() |>
    dplyr::arrange(!!topic,-beta) 
  
  if (!is.null(topic_names)) {
    data_top_terms <- data_top_terms |> 
      dplyr::mutate(topic = case_match(as.numeric(topic),
                                      1 ~ topic_names[1],
                                      2 ~ topic_names[2],
                                      3 ~ topic_names[3],
                                      4 ~ topic_names[4],
                                      5 ~ topic_names[5]
      ))
  }

  data_top_terms
}

#' Visualise top words per topic
#'
#' @param ... Arguments to be passed to `get_top_words_per_topic()`.
#'
#' @return `ggplot` bar chart of top n words faceted by topic.
#' @export
vis_top_words_per_topic <- function(...) {
  
  top_terms <- get_top_words_per_topic(...)
  
  top_terms |>
    ggplot2::ggplot(aes(reorder(term, beta), beta, fill = factor(topic))) +
    ggplot2::geom_col(show.legend = FALSE) +
    ggplot2::facet_wrap(~ topic, scales = "free_y", ncol = 3) +
    ggplot2::ylab("Beta") +
    ggplot2::xlab("Top terms") +
    ggplot2::labs(title = "Top n terms per topic") +
    ggplot2::coord_flip()
}

#' Visualise top words per topic
#'
#' @param ... Arguments to be passed to `get_top_words_per_topic()`.
#'
#' @return Word cloud of topics faceted by topic.
#' @export
vis_wordclouds_per_topic <- function(...) {
  
  top_terms <- get_top_words_per_topic(...) |> 
    mutate(angle = 90 * sample(c(0, 1), n(), replace = TRUE, prob = c(60, 40)))
  
  top_terms %>%
    ggplot2::ggplot(aes(label = term, size = beta, color = as.factor(topic), angle = angle)) +
    ggwordcloud::geom_text_wordcloud_area(rm_outside = TRUE, eccentricity = 1, rich_text = TRUE) +
    ggplot2::theme_minimal() +
    ggplot2::scale_size_area(max_size = 10) +
    ggplot2::scale_colour_discrete() +
    ggplot2::facet_wrap(~ topic)
}