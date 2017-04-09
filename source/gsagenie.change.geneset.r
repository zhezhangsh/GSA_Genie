gsagenie.change.geneset <- function(session, input, output, step1_status, chg.size = TRUE) {
  src <- input$step1.source;
  col <- input$step1.collection;
  spe <- input$step1.species;
  siz <- as.integer(input$step1.size);
  smx <- as.integer(input$step1.size.max);
  
  if (chg.size) step1_status$meta <- gsagenie.get.geneset(GENESET_HOME, src, col, spe) else {
    if (spe != step1_status$sel3) {
      updateSelectizeInput(session, 'step1.source', choices = names(geneset.mp[[spe]]));
      updateSelectizeInput(session, 'step1.collection', choices = geneset.mp[[spe]][[1]]);
      step1_status$meta <- gsagenie.get.geneset(GENESET_HOME, names(geneset.mp[[spe]])[1], geneset.mp[[spe]][[1]][1], spe);
      step1_status$sel1 <- names(geneset.mp[[spe]])[1];
      step1_status$sel2 <- geneset.mp[[spe]][[1]][1];
      step1_status$sel3 <- spe;
    } else if (src != step1_status$sel1) { # 'Source' selection is changed
      updateSelectizeInput(session, 'step1.collection', choices = geneset.mp[[spe]][[src]]);
      step1_status$meta <- gsagenie.get.geneset(GENESET_HOME, src, geneset.mp[[spe]][[src]][1], spe);
      step1_status$sel1 <- src;
      step1_status$sel2 <- geneset.mp[[spe]][[src]][1];
    } else if (col != step1_status$sel2) {
      step1_status$meta <- gsagenie.get.geneset(GENESET_HOME, src, col, spe);
      step1_status$sel2 <- col;
    } else {}
  };
  
  meta <- step1_status$meta;
  meta <- step1_status$meta <- meta[meta$Size>=siz & meta$Size<=smx, , drop=FALSE];
  output$step1.table <- DT::renderDataTable({
    if (identical(NULL, meta)) NULL else {
      meta <- cbind(ID=rownames(meta), meta);
      meta$ID <- AddHref(meta$ID, meta$URL);
      meta[, -ncol(meta)];
    }
  }, options=dt.options1, selection='multiple', rownames=FALSE, escape=FALSE);

  step1_status;
}