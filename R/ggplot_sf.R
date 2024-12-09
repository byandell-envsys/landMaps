#' Simple feature ggplot wrapper
#'
#' @param legend.position position of legend (default "bottom")
#' @param color scale color if not `NULL`
#'
#' @return gg plot object
#' @export
#' @importFrom ggplot2 aes element_text geom_sf geom_sf_label ggplot labs
#'             scale_color_manual theme theme_minimal xlab ylab
#' @importFrom ggrepel geom_text_repel
#' @importFrom rlang .data
ggplot_sf <- function(legend.position = "none",
                      color = c("grey", "black", "red")) {
  # Minimal theme, bottom legend.
  out <- ggplot2::ggplot() +
    ggplot2::xlab("Longitude") +
    ggplot2::ylab("Latitude") +
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.position = legend.position) +
    ggplot2::theme(strip.text.x = ggplot2::element_text(size = 10))
  if(!is.null(color) && length(color)) {
    # Name color by their value if not provided.
    color <- unique(color)
    if(is.null(names(color)))
      names(color) <- color
    out <- out +
      ggplot2::scale_color_manual(values = color)
  }
  out 
}
#' Simple feature ggplot geom_sf layer
#'
#' @param object simple feature object
#' @param color edge color
#' @param fill fill color
#' @param linewidth edge line width
#' @param ... additional parameters
#'
#' @return gg plot object
#' @export
#' @rdname ggplot_sf
ggplot_layer_sf <- function(object, 
                            color = "black", fill = "transparent",
                            linewidth = 0.5,
                            ...) {
  if(is.null(object) || !nrow(object)) return(NULL)
  
  # Set up color. See ggplot_nativeLand for another approach if legend desired.
  if(is.null(object$color))
    object$color <- color
  
  # List of ggplot2 objects for `+` addition.
  list(
    ggplot2::geom_sf(
      data = object,
      ggplot2::aes(color = .data$color),
      fill = fill,
      linewidth = linewidth,
      inherit.aes = FALSE, ...),
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(angle = 20, vjust = 0.5, hjust=1)))
}
#' Simple feature ggplot geom_text_reple label layer
#'
#' @param label column with label
#' @param ... additional parameters
#'
#' @return gg plot object
#' @export
#' @rdname ggplot_sf
ggplot_layer_name <- function(object,
                              label = "Name", color = "black", ...) {
  ggrepel::geom_text_repel(
#    ggplot2::geom_sf_label(
    data = object,
    ggplot2::aes(label = .data[[label]], geometry = .data$geometry,
                 size = 10),
    stat =  "sf_coordinates",
    size = 2, color = color, inherit.aes = FALSE)
}
