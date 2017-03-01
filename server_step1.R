server_step1 <- function(input, output, session, step1_status) {
  #######################################################################################################################
  #######################################################################################################################
  ## Step 1
  output$title.table <- DT::renderDataTable({
    tbl <- cbind(Source=rownames(geneset.smm), geneset.smm);
    colnames(tbl) <- sub('Num_', '', colnames(tbl));
    tbl$Source <- AddHref(sub('Miscellaneous/', '', tbl$Source), tbl$URL);
    tbl$Provider <- gsub(' ', '_', tbl$Provider);
    tbl$Description <- gsub(' ', '_', tbl$Description);
    tbl[, -ncol(tbl)];
  }, options=dt.options2, selection='single', rownames=FALSE, escape=FALSE);
  
  observeEvent(input$step1.size, {
    src <- input$step1.source;
    col <- input$step1.collection;
    spe <- input$step1.species;
    siz <- as.integer(input$step1.size);
    
    step1_status$meta <- gsagenie.get.geneset(GENESET_HOME, src, col, spe);
    meta <- step1_status$meta;
    meta <- step1_status$meta <- meta[meta$Size>=siz, , drop=FALSE];
    output$step1.table <- DT::renderDataTable({
      if (identical(NULL, meta)) NULL else {
        meta <- cbind(ID=rownames(meta), meta);
        meta$ID <- AddHref(meta$ID, meta$URL);
        meta[, -ncol(meta)];
      }
    }, options=dt.options1, selection='multiple', rownames=FALSE, escape=FALSE);
  });
  
  observeEvent(c(input$step1.source, input$step1.collection, input$step1.species), {
    src <- input$step1.source;
    col <- input$step1.collection;
    spe <- input$step1.species;
    siz <- as.integer(input$step1.size);
    
    if (src != step1_status$sel1) { # 'Source' selection is changed
      col <- geneset[[src]];
      updateSelectizeInput(session, 'step1.collection', choices = names(col));
      updateSelectizeInput(session, 'step1.species', choices = names(col[[1]]));
      step1_status$meta <- gsagenie.get.geneset(GENESET_HOME, src, names(col)[1], names(col[[1]])[1]);
      step1_status$sel1 <- src;
      step1_status$sel2 <- names(col)[1];
      step1_status$sel3 <- names(col[[1]])[1];
    } else if (col != step1_status$sel2) {
      isolate(updateSelectizeInput(session, 'step1.species', choices = names(geneset[[src]][[col]])));
      step1_status$meta <- gsagenie.get.geneset(GENESET_HOME, src, col, names(geneset[[src]][[col]])[1]);
      step1_status$sel2 <- col;
      step1_status$sel3 <- names(geneset[[src]][[col]])[1];
    } else if (spe != step1_status$sel3) {
      step1_status$meta <- gsagenie.get.geneset(GENESET_HOME, src, col, spe);
      step1_status$sel3 <- spe;
    } else {}
    
    meta <- step1_status$meta;
    meta <- step1_status$meta <- meta[meta$Size>=siz, , drop=FALSE];
    output$step1.table <- DT::renderDataTable({
      if (identical(NULL, meta)) NULL else {
        meta <- cbind(ID=rownames(meta), meta);
        meta$ID <- AddHref(meta$ID, meta$URL);
        meta[, -ncol(meta)];
      }
    }, options=dt.options1, selection='multiple', rownames=FALSE, escape=FALSE);
  });
  
  #########################################################################################################
  ## Download gene sets
  output$step1.download1 <- downloadHandler(
    filename = function() {
      fmt <- input$step1.format;
      fnm <- paste('metadata', input$step1.source, input$step1.collection, input$step1.species, sep='_');
      paste(fnm, fmt, sep='');
    },
    content  = function(file) {
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
  );
  output$step1.download2 <- downloadHandler(
    filename = function() {
      fmt <- input$step1.format;
      fnm <- paste('genesets', input$step1.source, input$step1.collection, input$step1.species, sep='_');
      paste(fnm, fmt, sep='');
    },
    content  = function(file) {
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
  );
  
  step1_status;
}