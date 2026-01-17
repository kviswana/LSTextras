#' Course-friendly replacement for LSTbook::point_plot when annot = "model"
#'
#' In the annot = "model" branch this function avoids LSTbook::point_plot()
#' and uses simple ggplot rules for common teaching cases.
#'
#' Change requested: in the y ~ x + z + w case, draw ONLY ONE smooth line per facet
#' (ignoring z in the fit), while still coloring points by z.
#'
#' When `annot = "model" and interval = "none"`, this function avoids `LSTbook::point_plot()` and uses
#' simplified ggplot logic for common course cases. Otherwise,
#' it delegates to `LSTbook::point_plot()`.
#'
#' @importFrom rlang .data
#' @param D A data frame.
#' @param tilde A formula like `y ~ x`, `y ~ x + z`, `y ~ x + z + w`.
#' @param ... Passed to `LSTbook::point_plot()` when `annot != "model"`.
#' @param annot Annotation mode; only `"model"` triggers the custom behavior.
#' @param interval Kept for compatibility; ignored when `annot = "model"`.
#' @param jitter Jitter width used when x is categorical (and for y ~ 1 case).
#' @param point_alpha Point transparency.
#' @param smooth_method Method passed to `geom_smooth()` (default `"lm"`).
#'
#' @return A ggplot object.
#' @export
point_plot <- function(
    D,
    tilde,
    ...,
    annot = c("none", "violin", "model", "bw"),
    interval = c("confidence", "none", "prediction"),
    jitter = 0.15,
    point_alpha = 0.7,
    smooth_method = "lm"
) {
  annot <- match.arg(annot)
  interval <- match.arg(interval)
  
  # Delegate unless model annotation requested
  if (!(annot == "model" & interval == "none")) {
    return(LSTbook::point_plot(D, tilde, ..., annot = annot, interval = interval))
  }
  
  if (!inherits(D, "data.frame")) stop("D must be a data.frame.")
  if (!inherits(tilde, "formula")) stop("tilde must be a formula.")
  
  # Robust extraction of response + predictors in order
  y_name <- all.vars(tilde[[2]])
  tt <- stats::terms(tilde)
  x_terms <- attr(tt, "term.labels")
  intercept <- isTRUE(attr(tt, "intercept") == 1)
  
  if (length(y_name) != 1) stop("Response must be a single variable (e.g., y).")
  if (length(x_terms) > 3) stop("This course version supports up to 3 predictors: y ~ x + z + w.")
  
  # ----------------
  # ----------------
  # CASE 0: y ~ 1  (no predictors; intercept-only)
  if (length(x_terms) == 0 && intercept) {
    df <- D[, y_name, drop = FALSE]
    df <- df[stats::complete.cases(df), , drop = FALSE]
    
    y <- df[[y_name]]
    if (!is.numeric(y)) stop("For this function, y must be numeric.")
    
    mean_y <- mean(y, na.rm = TRUE)
    
    # Put all points at x = 0 and jitter horizontally around 0
    df[[".x0"]] <- 0
    
    # Controls how wide the jitter cloud appears (match your screenshot feel)
    # jitter_width <- 0.35
    half_span <- 0.55  # x-limits to "frame" the cloud nicely
    
    return(
      ggplot2::ggplot(df, ggplot2::aes(x = .data[[".x0"]], y = .data[[y_name]])) +
        ggplot2::geom_jitter(width = jitter, height = 0, alpha = point_alpha) +
        # mean line (keep yours; this just spans the jitter cloud)
        ggplot2::geom_segment(
          x = -0.15, xend = 0.15,
          y = mean_y, yend = mean_y,
          linewidth = 1,
          color = "blue"
        ) +
        ggplot2::scale_x_continuous(limits = c(-half_span, half_span), breaks = NULL) +
        ggplot2::labs(x = NULL, y = y_name)
    )
  }
  
  
  # Everything below remains exactly the same as your original ----------------
  
  if (length(x_terms) < 1) stop("Formula must have at least one predictor (e.g., y ~ x).")
  
  x_name <- x_terms[1]
  z_name <- if (length(x_terms) >= 2) x_terms[2] else NULL
  w_name <- if (length(x_terms) >= 3) x_terms[3] else NULL
  
  # Work on complete cases for the variables involved
  needed <- c(y_name, x_name, z_name, w_name)
  needed <- needed[!is.null(needed)]
  df <- D[, needed, drop = FALSE]
  df <- df[stats::complete.cases(df), , drop = FALSE]
  
  y <- df[[y_name]]
  x <- df[[x_name]]
  z <- if (!is.null(z_name)) df[[z_name]] else NULL
  w <- if (!is.null(w_name)) df[[w_name]] else NULL
  
  if (!is.numeric(y)) stop("For this function, y must be numeric.")
  
  is_cat <- function(v) is.factor(v) || is.character(v) || is.logical(v)
  
  # ----------------
  # CASE 1: y ~ x, x numeric
  if (is.null(z_name) && is.numeric(x)) {
    return(
      ggplot2::ggplot(df, ggplot2::aes(x = .data[[x_name]], y = .data[[y_name]])) +
        ggplot2::geom_point(alpha = point_alpha) +
        ggplot2::geom_smooth(method = smooth_method, se = FALSE) +
        ggplot2::labs(x = x_name, y = y_name)
    )
  }
  
  # CASE 2: y ~ x, x categorical
  if (is.null(z_name) && is_cat(x)) {
    df[[x_name]] <- as.factor(df[[x_name]])
    
    means <- dplyr::summarise(
      dplyr::group_by(df, .data[[x_name]]),
      mean_y = mean(.data[[y_name]], na.rm = TRUE),
      .groups = "drop"
    )
    
    return(
      ggplot2::ggplot(df, ggplot2::aes(x = .data[[x_name]], y = .data[[y_name]])) +
        ggplot2::geom_jitter(width = jitter, height = 0, alpha = point_alpha) +
        ggplot2::geom_errorbar(
          data = means,
          ggplot2::aes(
            x = .data[[x_name]],
            ymin = .data[["mean_y"]],
            ymax = .data[["mean_y"]]
          ),
          width = 0.6,
          linewidth = 1,
          inherit.aes = FALSE,
          color = "blue"
        ) +
        ggplot2::labs(x = x_name, y = y_name)
    )
  }
  
  # CASE 3: y ~ x + z, x numeric, z categorical (line per z group is OK here)
  if (!is.null(z_name) && is.null(w_name) && is.numeric(x) && is_cat(z)) {
    df[[z_name]] <- as.factor(df[[z_name]])
    
    return(
      ggplot2::ggplot(df, ggplot2::aes(x = .data[[x_name]], y = .data[[y_name]], color = .data[[z_name]])) +
        ggplot2::geom_point(alpha = point_alpha) +
        ggplot2::geom_smooth(method = smooth_method, se = FALSE) +
        ggplot2::labs(x = x_name, y = y_name, color = z_name)
    )
  }
  
  # CASE 4: y ~ x + z + w, z categorical, facet by w, color by z
  # Requested change: ONLY ONE smooth line per facet (ignore z in fit)
  # 4a) x numeric
  if (!is.null(z_name) && !is.null(w_name) && is.numeric(x) && is_cat(z)) {
    df[[z_name]] <- as.factor(df[[z_name]])
    df[[w_name]] <- as.factor(df[[w_name]])
    
    p <- ggplot2::ggplot(df, ggplot2::aes(x = .data[[x_name]], y = .data[[y_name]])) +
      ggplot2::geom_point(ggplot2::aes(color = .data[[z_name]]), alpha = point_alpha) +
      # single line per facet: DO NOT map color; group = 1 forces one fit
      ggplot2::geom_smooth(
        ggplot2::aes(group = 1),
        method = smooth_method,
        se = FALSE
      ) +
      ggplot2::facet_wrap(stats::as.formula(paste("~", w_name))) +
      ggplot2::labs(x = x_name, y = y_name, color = z_name)
    
    return(p)
  }
  
  # 4b) x categorical
  if (!is.null(z_name) && !is.null(w_name) && is_cat(x) && is_cat(z)) {
    df[[x_name]] <- as.factor(df[[x_name]])
    df[[z_name]] <- as.factor(df[[z_name]])
    df[[w_name]] <- as.factor(df[[w_name]])
    
    return(
      ggplot2::ggplot(df, ggplot2::aes(x = .data[[x_name]], y = .data[[y_name]])) +
        ggplot2::geom_jitter(
          ggplot2::aes(color = .data[[z_name]]),
          width = jitter,
          height = 0,
          alpha = point_alpha
        ) +
        ggplot2::facet_wrap(stats::as.formula(paste("~", w_name))) +
        ggplot2::labs(x = x_name, y = y_name, color = z_name)
    )
  }
  
  stop(
    "Unsupported combination.\n",
    "Supported:\n",
    "  (0) y ~ 1 (intercept-only)\n",
    "  (1) y ~ x (x numeric)\n",
    "  (2) y ~ x (x categorical)\n",
    "  (3) y ~ x + z (x numeric, z categorical)\n",
    "  (4) y ~ x + z + w (z categorical; facet by w; x numeric or categorical)\n"
  )
}
