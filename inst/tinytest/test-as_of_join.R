# Create mock data for tests
set.seed(42)
hours <- timeBasedSeq("2023-01-01/2023-01-02/H")
hours_xts <- xts(seq_along(hours), hours + 60 * runif(length(hours)))

mins <- timeBasedSeq("2023-01-01/2023-01-02/M")
mins_xts <- xts(seq_along(mins), mins)

# Test 1: Left join using our fast C function
info_msg <- "Left join result row count and index match left object"
left_res <- as_of_join(hours_xts, mins_xts, join = "left")
expect_equal(nrow(left_res), nrow(hours_xts), info = info_msg)
expect_equal(index(left_res), index(hours_xts), info = info_msg)

# Minimal reproducible example:
# Ensure as-of join works on simple data
info_msg <- "as-of join merges nearest previous record"
x <- .xts(1:3, c(1, 5, 10))
y <- .xts(11:13, c(2, 4, 9))
res <- as_of_join(x, y, join="left")
expect_equal(NROW(res), 3, info = info_msg)
expect_equal(as.numeric(res[,2]), c(NA, 12, 13), info = info_msg)
