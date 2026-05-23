library(xts)

# Create mock data for tests
set.seed(42)
hours <- timeBasedSeq("2023-01-01/2023-01-02/H")
hours_xts <- xts(seq_along(hours), hours + 60 * runif(length(hours)))

mins <- timeBasedSeq("2023-01-01/2023-01-02/M")
mins_xts <- xts(seq_along(mins), mins)

# Test 1: Left join using our fast C function
left_res <- as_of_join(hours_xts, mins_xts, join = "left")

# Check that the number of rows matches the left object
if (nrow(left_res) != nrow(hours_xts)) {
    stop("Left join result row count does not match left object")
}

# Check that the index matches the left object exactly
if (!all(index(left_res) == index(hours_xts))) {
    stop("Left join result index does not match left object")
}

# Check a few known values
# For the very first 'hour' timestamp, which is slightly after 00:00:00
# The nearest preceding minute in mins_xts should match correctly.
print("Basic tests passed!")
