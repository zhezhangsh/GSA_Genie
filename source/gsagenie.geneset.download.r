gsagenie.geneset.download1 <- function(input, step1_status, file) {
  fmt <- tolower(input$step1.format)[1];
  tbl <- step1_status$meta;
  if (!identical(NULL, tbl)) {
    rws <- input$step1.table_rows_selected; 
    if (length(rws) > 0) tbl <- tbl[rws, , drop=FALSE];
    if (identical(fmt, '.rdata')) save(tbl, file=file) else if (identical(fmt, '.rds')) saveRDS(tbl, file) else {
      tbl <- cbind(ID=rownames(tbl), tbl);
      write.table(tbl, file, sep='\t', qu=FALSE, row=FALSE, col=TRUE);
    }
  }  
}

gsagenie.geneset.download2 <- function(input, step1_status, file) {
  fmt <- tolower(input$step1.format)[1];
  src <- input$step1.source;
  col <- input$step1.collection;
  spe <- input$step1.species;
  idf <- input$step1.identifier;
  siz <- as.integer(input$step1.size);
  lst <- gsagenie.get.mapping(GENESET_HOME, src, col, spe, idf);
  tbl <- step1_status$meta;
  
  if (!identical(NULL, tbl)) {
    rws <- input$step1.table_rows_selected; 
    if (length(rws) > 0) tbl <- tbl[rws, , drop=FALSE];
    lst <- lst[rownames(tbl)];
    if (length(lst) > 0) {
      if (identical(fmt, '.rdata')) save(lst, file=file) else if (identical(fmt, '.rds')) saveRDS(lst, file) else {
        lns <- sapply(lst, function(l) paste(l, collapse='\t'));
        lns <- paste(rownames(tbl), tbl$Name, lns, sep='\t');
        writeLines(lns, file);
      }
    }
  }
}