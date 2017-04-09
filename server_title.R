server_title <- function(input, output, session) {
  #######################################################################################################################
  ## title
  # observeEvent(input$detail.show, updateCheckboxInput(session, 'detail', value=TRUE));
  observeEvent(input$detail.hide, updateCheckboxInput(session, 'detail', value=FALSE));
  
  observeEvent(input$detail.show, {
    updateCheckboxInput(session, 'detail', value=TRUE);
    output$title.table <- DT::renderDataTable({ 
      tbl <- cbind(Source=rownames(geneset.smm), geneset.smm);
      colnames(tbl) <- sub('Num_', '', colnames(tbl));
      tbl$Source <- AddHref(sub('Miscellaneous/', '', tbl$Source), tbl$URL);
      tbl$Provider <- gsub(' ', '_', tbl$Provider);
      tbl$Description <- gsub(' ', '_', tbl$Description);
      tbl[, -ncol(tbl)];
    }, options=dt.options2, selection='single', rownames=FALSE, escape=FALSE);
  });
  
  observeEvent(input$title.coll1, {
    tbl <- collection.smm[[input$title.coll1]];
    updateSelectizeInput(session, 'title.coll2', choices=c('All', sort(unique(tbl$Category)))); 
  });
  output$title.collection <- DT::renderDataTable({ 
    cl1 <- input$title.coll1; 
    cl2 <- input$title.coll2; 
    tbl <- collection.smm[[cl1]]; 
    if (cl2 != 'All') tbl <- tbl[tbl$Category==cl2, , drop=FALSE];
    FormatNumeric(tbl);
  }, options=dt.options1, selection='none', rownames=FALSE); 
  
  observeEvent(input$title.search, {
    spe <- input$title.species;
    key <- input$title.keyword;
    exc <- input$title.exact;
    
    if (key!='' & file.exists(metadata.fn[spe])) {
      withProgress({
        setProgress(value=0.05);
        mta <- readRDS(metadata.fn[spe]); 
        setProgress(value=0.2);
        if (exc=='1') ind1 <- grep(key, rownames(mta), ignore.case = TRUE) else 
          ind1 <- agrep(key, rownames(mta), ignore.case = TRUE);
        setProgress(value=0.5);
        if (exc=='1') ind2 <- grep(key, mta$Name, ignore.case = TRUE) else 
          ind2 <- agrep(key, mta$Name, ignore.case = TRUE); 
        setProgress(value=0.9);
        output$title.found <- DT::renderDataTable({ 
          tbl <- mta[union(ind1, ind2), , drop=FALSE]; 
          tbl <- cbind(ID=AddHref(rownames(tbl), tbl$URL), tbl[, -ncol(tbl), drop=FALSE]);
          tbl; 
        }, options=dt.options1, selection='none', rownames=FALSE, escape=FALSE);
      }, message = "Searching gene sets ... ...", detail = 'please wait')
    }
  }); 
}