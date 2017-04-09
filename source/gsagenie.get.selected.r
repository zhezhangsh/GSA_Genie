gsagenie.get.selected <- function(input, step1_status, step3_status) {
  mul <- step1_status$multiple; 
  typ <- as.integer(step3_status$type);
  if (is.null(mul)) {
    if (typ==3) ch1 <- as.integer(input$step3c.collection) else ch1 <- as.integer(input$step3ab.collection);
    sel <- step1_status$meta;
    rid <- input$step1.table_rows_selected; 
    if (is.na(ch1)) ch1 <- 0; 
    if (length(rid)>0 & ch1==0) sel <- sel[rid, , drop=FALSE];
    mul <- list(rownames(sel));
    names(mul) <- paste(input$step1.source, input$step1.collection, sep='; ');
  };
  mul;
}