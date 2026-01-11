
# LSTextras

<!-- badges: start -->
<!-- badges: end -->

I created the LSTextras package to facilitate my teaching approach to business statistics. 
I adopted the book Lessons in Statistical Thinking by Daniel Kaplan for my course. 
I really like the model-centric approach and the philosophy of that book. But, after a few semesters
I felt that students will more easily grasp the ideas if we first introduced the notion of a model
purely from the viewpoint of a single dataset without even mentioning the sample-population distinction.
This treats the model as intended only for the dataset used. Once students have grasped the idea of least-squares, 
R-squared and other related ideas, we can then transition to inference and introduce statistical models and 95% confidence bands, and 
other topics like probability and hypothesis testing. 
 
LSTextras minimally extends the functionality of the LSTbook package by overriding the behavior of the point_plot function for a few special cases.
zSpecifically, the point_plot function of LSTbook is only able to plot bands for model annotations. When we use interval = "none" it sometimes fails. 
When it does not fail, it still plots bands. Therefore we do not have any way of just showing lines for model annotations and this gets in the way of
gradually moving students along my chosen path.

Additionally LSTextras provides several specially created synthetic datasets set in a business context to illustrate specific concepts.

## Installation

You can install the development version of LSTextras like so:

``` r
install.packages("pak")
pak::pkg_install("kviswana/LSTextras")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(LSTbook)
library(LSTextras)
## basic example code
```

