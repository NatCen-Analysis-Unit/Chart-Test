install.packages("rvg", repos = "https://www.stats.bris.ac.uk/R/")

setwd('F:/Projects/Chart Test')

library(mschart)
library(officer)


# example chart 01 -------

scatter <-
  ms_scatterchart(
    data = iris, x = "Sepal.Length",
    y = "Sepal.Width", group = "Species"
  )
scatter <- chart_settings(scatter, scatterstyle = "marker")

doc <- read_pptx("F:/Projects/Chart Test/NC.pptx")
doc <- add_slide(doc, layout = "Title and full width content", master = "NatCenTheme")
doc <- ph_with(doc, value = "Chart Title", location = ph_location_type(type = "title"))
doc <- ph_with(doc, value = scatter, location = ph_location_type(type = "body"))
doc <- add_slide(doc, layout = "Title and full width content", master = "NatCenTheme")
doc <- ph_with(doc, value = "Chart Title", location = ph_location_type(type = "title"))
doc <- ph_with(doc, value = scatter, location = ph_location_type(type = "body"))

print(doc, target = "example.pptx")

add <- function(document, chart, title) {
  document <- add_slide(document, layout = "Title and single content", master = "NatCenTheme")
  document <- ph_with(document, value = title, location = ph_location_type(type = "title"))
  document <- ph_with(document, value = chart, location = ph_location_type(type = "body"))
  return (document)
}

output <- add(doc, scatter, "Try this")
print(output, target = "example.pptx")
