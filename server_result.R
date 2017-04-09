server_result <- function(input, output, session, step1_status, step2_status, step3_status, result_status) {
  result.tbl <- reactive({
    res <- step3_status$result;
    if (is.null(res)) NULL else {
      tbl <- step3_status$metadata;
      tbl$ID <- AddHref(tbl$ID, tbl$URL);
      tbl <- cbind(tbl[, 1:3, drop=FALSE], FormatNumeric(res));
      updateCheckboxInput(session, 'result_split', value = length(unique(tbl$Collection))>1);
      tbl;
    };
  });
  
  observeEvent(input$run.back, {
    step3_status <- gsagenie.reset.step3(session, input, output, step1_status, step2_status, step3_status, event='go_back');
  });
  
  observeEvent(input$result.back, {
    result_status <- gsagenie.reset.run(session, input, output, step1_status, step2_status, step3_status, result_status, event='go_back');
  });
  
  observeEvent(input$startover.button, {
    result_status <- gsagenie.reset.run  (session, input, output, step1_status, step2_status, step3_status, result_status, event='go_back');
    step3_status  <- gsagenie.reset.step3(session, input, output, step1_status, step2_status, step3_status, event='go_back');
    step2_status  <- gsagenie.reset.step2(session, input, output, step1_status, step2_status, event='go_back');
  });
  
  observeEvent(input$run.button, {
    withProgress({
      step3_status <- gsagenie.run.analysis(input, step1_status, step2_status, step3_status);
    }, message = 'Running GSA ...', detail = 'please wait');
    
    TrackActivity(session, action = 'Run GSA', dir = 'log',
                  data = list(step1_status=step1_status, step2_status=step2_status, step3_status=step3_status));
    
    res <- step3_status$result;
    updateCheckboxInput(session, 'step3_show', value=is.null(res));
    updateCheckboxInput(session, 'result_show', value=!is.null(res));
    updateCheckboxInput(session, 'run_button', value=is.null(res));
    updateCheckboxInput(session, 'result_button', value=!is.null(res));
    updateCheckboxInput(session, 'result_split', value=FALSE);
    updateCheckboxInput(session, 'result.split', value=FALSE);

    output$result.table <- DT::renderDataTable({ result.tbl();
    }, options=dt.options1, selection='single', rownames=FALSE, escape=FALSE);
  });

  observeEvent(input$result.split, {
    tbl <- result.tbl();
    if (input$result.split) {
      cll <- unique(tbl$Collection);
      tbl <- tbl[tbl$Collection==cll[1], , drop=FALSE];
      updateSelectizeInput(session, 'result.collection', choices = cll); 
    }
    output$result.table <- DT::renderDataTable({ tbl;
    }, options=dt.options1, selection='single', rownames=FALSE, escape=FALSE);
  });
  observeEvent(input$result.collection, {
    tbl <- result.tbl();
    if (input$result.split) tbl <- tbl[tbl$Collection==input$result.collection, , drop=FALSE];
    output$result.table <- DT::renderDataTable({ tbl; 
      }, options=dt.options1, selection='single', rownames=FALSE, escape=FALSE);
  });
  
  observeEvent(input$result.table_rows_selected, {
    gsagenie.result.row(session, input, output, step1_status, step2_status, step3_status, result_status, result.tbl());
  });
  
  ## Download gene sets
  output$result.download0 <- downloadHandler(
    filename = function() { 'gsa.rdata' },
    content  = function(file) { gsagenie.result.download0(input, step1_status, step2_status, step3_status, file) }
  );
  
  output$result.download1 <- downloadHandler(
    filename = function() { 'result.txt'},
    content  = function(file) { gsagenie.result.download1(input, step1_status, step2_status, step3_status, file) }
  );
  
  output$result.download2 <- downloadHandler(
    filename = function() { 'genes.txt'},
    content  = function(file) { write.table(result_status$geneset, file, sep='\t', qu=FALSE, row=FALSE, col=TRUE); }
  );
  
  result_status;
}