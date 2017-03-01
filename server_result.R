server_result <- function(input, output, session, step1_status, step2_status, step3_status, result_status) {
  observeEvent(input$run.back, {
    step3_status <- gsagenie.reset.step3(session, input, output, step1_status, step2_status, step3_status, event='go_back');
  });
  
  observeEvent(input$result.back, {
    result_status <- gsagenie.reset.run(session, input, output, step1_status, step2_status, step3_status, result_status, event='go_back');
  });
  
  observeEvent(input$startover.button, {
    result_status <- gsagenie.reset.run(session, input, output, step1_status, step2_status, step3_status, result_status, event='go_back');
    step3_status <- gsagenie.reset.step3(session, input, output, step1_status, step2_status, step3_status, event='go_back');
    step2_status <- gsagenie.reset.step2(session, input, output, step1_status, step2_status, event='go_back');
  });
  
  observeEvent(input$run.button, {
    withProgress({
      step3_status <- gsagenie.run.analysis(input, step1_status, step2_status, step3_status);
    }, message = 'Running GSA ...', detail = 'please wait');
    
    res <- step3_status$result;
    if (is.null(res)) {
      updateCheckboxInput(session, 'step3_show', value=TRUE);
      updateCheckboxInput(session, 'result_show', value=FALSE);
      updateCheckboxInput(session, 'run_button', value=TRUE);
      updateCheckboxInput(session, 'result_button', value=FALSE);
    } else {
      updateCheckboxInput(session, 'step3_show', value=FALSE);
      updateCheckboxInput(session, 'result_show', value=TRUE);
      updateCheckboxInput(session, 'run_button', value=FALSE);
      updateCheckboxInput(session, 'result_button', value=TRUE);
    };
    
    output$result.table <- DT::renderDataTable({
      if (is.null(res)) NULL else {
        tbl <- data.frame(rownames(res), step1_status$meta[rownames(res), 'Name'], FormatNumeric(res), stringsAsFactors = FALSE);
        colnames(tbl) <- c('ID', 'Name', colnames(res)); 
        tbl$ID <- AddHref(tbl$ID, step1_status$meta[rownames(res), 'URL']);
        tbl;
      }
    }, options=dt.options1, selection='single', rownames=FALSE, escape=FALSE);
  });
  
  observeEvent(input$result.table_rows_selected, {
    rid <- input$result.table_rows_selected;
    if (length(rid) == 0) {
      updateCheckboxInput(session, 'result_plot', value=FALSE);
      output$result.geneset <- DT::renderDataTable({ NULL; });
      output$result.plot <- renderPlotly({ plotly_empty(); })
    } else {
      updateCheckboxInput(session, 'result_plot', value=TRUE);
      
      typ <- step3_status$type;
      
      if (typ==1 | typ==2) {
        rnm <- rownames(step3_status$result)[rid];
        bgd <- step3_status$background;
        gst <- step3_status$geneset[rnm][[1]];
        gst <- unique(gst[gst %in% bgd]);
        if (length(step2_status$list) > 0) gns <- step2_status$list else gns <- step2_status$top;
        gns <- unique(gns[gns %in% bgd]); 
        tbl <- step2_status$table;
        win <- rep(0, length(gns));
        win[gns %in% gst] <- 1;
        names(win) <- gns;
        if (is.null(tbl)) {
          out <- data.frame(ID=gns, Within_Geneset=as.vector(win), stringsAsFactors = FALSE);
        } else {
          out <- tbl[rownames(tbl) %in% gns, , drop=FALSE];
          out <- data.frame(ID=rownames(out), Within_Geneset=as.vector(win[rownames(out)]), out, stringsAsFactors = FALSE);
        };
        result_status$geneset <- out; 
        output$result.geneset <- DT::renderDataTable({ 
          FormatNumeric(out);
        }, options=dt.options3, selection='none', rownames=FALSE, escape=FALSE);
        
        output$result.plot <- renderPlotly({
          xaxis <- list(title='', range=c(0.5, 3.75), zeroline=FALSE, showgrid=FALSE, showline=FALSE, autotick=FALSE, showticklabels=FALSE);
          yaxis <- list(title='', range=c(0.5, 3.75), zeroline=FALSE, showgrid=FALSE, showline=FALSE, autotick=FALSE, showticklabels=FALSE);
          tfont <- list(family = "sans serif", size = 16, color = toRGB("grey50")); 
          shap1 <- list(type='circle', xref='x', yref='y', x0=0.5, x1=2.5, y0=1, y1=3, fillcolor='blue', opacity=0.3, line=list(color='black', width=1)); 
          shap2 <- list(type='circle', xref='x', yref='y', x0=1.5, x1=3.5, y0=1, y1=3, fillcolor='red',  opacity=0.3, line=list(color='black', width=1)); 
          
          l0 <- length(intersect(gst, gns));
          l1 <- length(gns) - l0;
          l2 <- length(gst) - l0;
          l  <- length(bgd) - l0 - l1 - l2;
          
          x  <- c(1, 2, 3, 2, 1, 3); 
          y  <- c(2, 2, 2, 0.75, 3.25, 3.25);
          tt <- c(l1, l0, l2, l, c("User's gene list", rnm)); 
          
          output$result.geneset <- DT::renderDataTable({ 
            FormatNumeric(out);
          }, options=dt.options3, selection='none', rownames=FALSE, escape=FALSE);
          
          plot_ly(x=x, y=y, type='scatter', mode='text', text=tt, textfont = tfont) %>% 
            layout(shapes=list(shap1, shap2), showlegend=FALSE, xaxis=xaxis, yaxis=yaxis);
        });
      } else {
        rnm <- rownames(step3_status$result)[rid];
        gst <- step3_status$geneset[rnm][[1]];
        tbl <- step2_status$table;
        tb0 <- tbl[rownames(tbl) %in% gst, , drop=FALSE];
        st0 <- step3_status$stat;
        stt <- st0[rownames(tb0)];
        out <- data.frame(ID=rownames(tb0), Statistics=stt, tb0, stringsAsFactors = FALSE);
        result_status$geneset <- out; 
        
        output$result.geneset <- DT::renderDataTable({ 
          FormatNumeric(out);
        }, options=dt.options3, selection='none', rownames=FALSE, escape=FALSE);
        
        output$result.plot <- renderPlotly({
          v1 <- st0[names(st0) %in% gst];
          v0 <- st0[!(names(st0) %in% gst)];
          if (length(v1)>1 & length(v0)>1) {
            den1 <- density(v1);
            den0 <- density(v0); 
            plot_ly(x=~den1$x, y=~den1$y, type = 'scatter', mode = 'lines', name = rnm, fill = 'tozeroy') %>%  
              add_trace(x = ~den0$x, y = ~den0$y, name = 'Other genes', fill = 'tozeroy') %>% 
              layout(xaxis = list(title = 'Gene-level statistics'),yaxis = list(title = 'Density'))
            
          } else plotly_empty();
        });
      }
    }
  });
  
  ## Download gene sets
  output$result.download1 <- downloadHandler(
    filename = function() { 'result.txt'},
    content  = function(file) {
      res <- step3_status$result;
      mta <- step1_status$meta[rownames(res), , drop=FALSE];
      tbl <- data.frame(ID=rownames(res), mta[, 2:4], res, URL=mta$URL);
      write.table(tbl, file, sep='\t', qu=FALSE, row=FALSE, col=TRUE);
    }
  );
  
  output$result.download2 <- downloadHandler(
    filename = function() { 'genes.txt'},
    content  = function(file) {
      write.table(result_status$geneset, file, sep='\t', qu=FALSE, row=FALSE, col=TRUE);
    }
  );
  
  result_status;
}