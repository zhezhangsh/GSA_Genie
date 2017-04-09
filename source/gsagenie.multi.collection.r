gsagenie.multi.collection <- function(session, input, output, step1_status, choice) {
  sl  <- step1_status$multiple;
  i   <- 1;

  if (choice == 0) {
    df <- geneset.df1[geneset.df1$species==input$step1.species, , drop=FALSE];
    id <- geneset.df2[rownames(df)];
    names(id) <- paste(df$source, df$collection, sep='; ');
    id <- c(id, sl);
    id <- split(id, names(id))[unique(names(id))];
    sl <- lapply(id, function(x) unique(unlist(x, use.names=FALSE)));
  } else if (choice == 1) {
    rws <- rownames(step1_status$meta); 
    ind <- input$step1.table_rows_selected;
    nam <- paste(input$step1.source, input$step1.collection, sep='; ');
    if (length(ind) > 0) rws <- rws[ind];
    if (nam %in% names(sl)) sl[[nam]] <- unique(c(rws, sl[[nam]])) else sl[[nam]] <- rws;
    i <- which(names(sl) == nam);
  } else if (choice == -1) {
    ind <- as.integer(input$step1.multi.selected);
    if (length(sl)<2) sl <- NULL else sl <- sl[-ind];
  };
  
  if (length(sl) == 0) {
    updateSelectizeInput(session, 'step1.multi.selected', choices = list(), selected = NULL);
    output$step1.multi.msg <- renderUI({ h6(HTML('<font color="white">No gene sets selected</font>')); });
  } else {
    n <- sum(sapply(sl, length)); 
    if (n > geneset.max) {
      output$step1.multi.msg <- renderUI({ 
        h6(HTML(paste('<font color="red">Too many gene sets (Maximum = ', geneset.max, ')</font>', sep=''))); });
    } else {
      op <- as.list(1:length(sl));
      names(op) <- paste(names(sl), paste(sapply(sl, length), 'gene sets'), sep='; ');
      updateSelectizeInput(session, 'step1.multi.selected', choices = op, selected = i);
      
      output$step1.multi.msg <- renderUI({
        if (input$step1.multiple) {
          sel <- step1_status$multiple; 
          if (is.null(sel)) h6(HTML('<font color="white">No gene sets selected</font>')) else 
            h6(HTML(paste('<font color="white">', sum(sapply(sel, length)), ' gene set(s), ', length(sel), ' collection(s)</font>', sep='')));
        } else h6(HTML(''))
      });
    }
  };
  
  step1_status$multiple <- sl;
  step1_status;
}