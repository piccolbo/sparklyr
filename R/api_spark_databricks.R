spark_api_read_csv <- function(api,
                               path,
                               csvOptions = list(),
                               columns = NULL) {
  read <- invoke(spark_sql_or_hive(api), "read")
  options <- invoke(read, "format", "com.databricks.spark.csv")
  
  lapply(names(csvOptions), function(csvOptionName) {
    options <<- invoke(options, "option", csvOptionName, csvOptions[[csvOptionName]])
  })
  
  if (identical(columns, NULL)) {
    optionSchema <- invoke(options, "option", "inferSchema", "true")
  }
  else {
    columnDefs <- spark_api_build_types(api, columns)
    optionSchema <- invoke(options, "schema", columnDefs)
  }

  invoke(optionSchema, "load", path)
}

spark_api_write_csv <- function(df, path, csvOptions) {
  write <- invoke(df, "write")
  options <- invoke(write, "format", "com.databricks.spark.csv")
  
  lapply(names(csvOptions), function(csvOptionName) {
    options <<- invoke(options, "option", csvOptionName, csvOptions[[csvOptionName]])
  })
  
  invoke(options, "save", path)

  invisible(TRUE)
}
