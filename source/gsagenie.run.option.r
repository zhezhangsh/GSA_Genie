gsagenie.run.option <- function(session, input, output, step1_status, step2_status, step3_status) {
  ################################################################################################
  if (length(step2_status$list) > 0) typ <- c("A - User's gene list vs. background"=1) else
    if (length(step2_status$top) > 0) typ <- c("B - Selected genes vs. background"=2)   else
      if (!is.null(step2_status$table)) typ <- c('C - Compare gene-level statistics'=3)  else 
        typ <- c('Unknown'=0);
  step3_status$type <- typ;
  # typ <- step3_status$type;
  if (!is.null(step1_status$multiple)) ch1 <- c('Collections from Step 1'=-1) else {
    ch1 <- c('Full table from Step 1'=1);
    if (length(input$step1.table_rows_selected) > 0) ch1 <- c('Highlighted by user'=0, ch1);      
  }; 
  if (typ==1 | typ==2) {
    updateSelectizeInput(session, 'step3ab.collection', choices = ch1);
    
    ch2 <- c('All known genes'=1, 'All genes in collection'=2);
    if (length(step2_status$background) > 0 | !is.null(step2_status$table)) ch2 <- c('Uploaded by Step 2'=0, ch2);
    updateSelectizeInput(session, 'step3ab.background', choices = ch2);
  } else if (typ == 3) {
    updateSelectizeInput(session, 'step3c.collection',  choices = ch1); 
    
    ###########################################################################
    cnm <- input$step2b.column;
    tbl <- step2_status$table;
    stt <- tbl[, cnm];
    rng <- range(stt, na.rm=TRUE);
    nms <- colnames(tbl);
    nms <- nms[sapply(nms, function(i) {
      if (!is.numeric(tbl[, i]) | i==cnm) FALSE else {
        rng <- range(tbl[, i], na.rm=TRUE);
        rng[1]<0 & rng[2]>0;
      };
    })];
    if (length(nms) == 0) ch2 <- list("Not available" = -1) else {
      ch2 <- as.list(c(0, sapply(nms, function(n) which(colnames(tbl)==n))));
      names(ch2) <- c("Don't use", nms); 
    };
    
    ####################### set selectizer based on the type of variable #######################
    if (rng[1]>=0 & rng[2]<=1) { # p-like
      updateSelectizeInput(session, 'step3c.type',      choices = stat.type[c(1, 4)]); 
      updateSelectizeInput(session, 'step3c.direction', choices = ch2); 
      updateSelectizeInput(session, 'step3c.rescale',   choices = resc.type); 
    } else if (rng[1]<0 & rng[2]>0) { # t-like
      updateSelectizeInput(session, 'step3c.type',      choices = stat.type[c(2, 4)]); 
      updateSelectizeInput(session, 'step3c.direction', choices = list('Not applicable'=-1)); 
      updateSelectizeInput(session, 'step3c.rescale',   choices = resc.type[-3]); 
    } else if (rng[1]>0) { # f-like
      updateSelectizeInput(session, 'step3c.type',      choices = stat.type[c(3, 4)]); 
      updateSelectizeInput(session, 'step3c.direction', choices = ch2); 
      updateSelectizeInput(session, 'step3c.rescale',   choices = resc.type); 
    } else { # others
      updateSelectizeInput(session, 'step3c.type',      choices = stat.type[c(4, 1:3)]); 
      updateSelectizeInput(session, 'step3c.direction', choices = ch2); 
      updateSelectizeInput(session, 'step3c.rescale',   choices = resc.type); 
    }
  } else {};
  
  updateCheckboxInput(session, 'detail',       value=FALSE);
  updateCheckboxInput(session, 'step2_show',   value=FALSE);
  updateCheckboxInput(session, 'step3_subset', value=as.vector(typ)<3);
  updateCheckboxInput(session, 'step3_show',   value=TRUE);
  updateCheckboxInput(session, 'step3_button', value=FALSE);
  updateCheckboxInput(session, 'run_button',   value=TRUE);

  step3_status;
}