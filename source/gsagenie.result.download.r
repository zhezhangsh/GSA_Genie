gsagenie.result.download0 <- function(input, step1_status, step2_status, step3_status, file) {
  cll <- list(source=input$step1.source, collection=input$step1.collection, species=input$step1.species, 
              size=input$step1.size, metadata=step3_status$metadata);
  inp <- list(genelist=step2_status$list, background=step2_status$background, table=step2_status$table, top=step2_status$top);
  gst <- step3_status$geneset;
  if (step3_status$type==1) {
    c <- as.integer(input$step3ab.collection);
    if (c==0) c <- 'Highlighted by user' else c <- 'Full table from Step 1'
    b <- as.integer(input$step3ab.background);
    if (b==0) b <- 'Uploaded by Step 2' else if (b==1) b <- 'All known genes' else b <- 'All genes in collection'
    prm <- list(collection=c, background=b, method=names(ora.method)[as.integer(input$step3ab.method)]);
  } else {
    c <- as.integer(input$step3c.collection);
    if (c==0) c <- 'Highlighted by user' else c <- 'Full table from Step 1';
    d <- as.integer(input$step3c.direction);
    if (d==-1) d <- "Not available" else if (d==0) d <- "Don't use" else d <- colnames(step2_status$table)[d];
    prm <- list(collection=c, direction=d, rescale=names(resc.type)[as.integer(input$step3c.rescale)+1], 
                method=input$step3c.method, stat=step3_status$stat);
  }
  res <- step3_status$result;
  gsa <- list(collection=cll, input=inp, geneset=gst, parameter=prm, result=res);
  save(gsa, file=file);
}; 

gsagenie.result.download1 <- function(input, step1_status, step2_status, step3_status, file) {
  res <- step3_status$result;
  mta <- step3_status$metadata;
  tbl <- cbind(mta, res); 
  colnames(tbl) <- c(colnames(mta), colnames(res)); 
  write.table(tbl, file, sep='\t', qu=FALSE, row=FALSE, col=TRUE);
}; 