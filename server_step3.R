server_step3 <- function(input, output, session, step1_status, step2_status, step3_status) { 
  observeEvent(input$step3.back, {
    step2_status <- gsagenie.reset.step2(session, input, output, step1_status, step2_status, event='go_back');
  });
  
  observeEvent(c(input$step3c.type, input$step3c.direction, input$step3c.rescale), {
    typ <- as.integer(input$step3c.type);
    dir <- as.integer(input$step3c.direction);
    rsc <- as.integer(input$step3c.rescale);
    mt0 <- input$step3c.method;
    
    if (!is.na(typ) & !is.na(dir) & !is.na(rsc)) {
      if (typ==0 | rsc==3) {
        mth <- gsa.method[gsa.method$Rank_Like==1, , drop=FALSE];
      } else if (typ==2) {
        mth <- gsa.method[gsa.method$T_Like==1, , drop=FALSE];
      } else if (typ==1) {
        if (rsc==0) mth <- gsa.method[gsa.method$P_Like==1, , drop=FALSE] else
          if (dir==0) mth <- gsa.method[gsa.method$Rank_Like==1, , drop=FALSE] else
            mth <- gsa.method[gsa.method$T_Like==1, , drop=FALSE];
      } else if (typ==3) {
        if (rsc==0) mth <- gsa.method[gsa.method$F_Like==1, , drop=FALSE] else
          if (dir==0) mth <- gsa.method[gsa.method$Rank_Like==1, , drop=FALSE] else
            mth <- gsa.method[gsa.method$T_Like==1, , drop=FALSE];
      } else {
        mth <- gsa.method;
      };
      
      rid <- input$step1.table_rows_selected;
      if (length(rid)>0) ngs <- length(rid) else ngs <- nrow(step1_status$meta); 
      if (ngs>5) mth <- mth[mth$Name!='gsea', , drop=FALSE];
      if (ngs>50) mth <- mth[mth$Speed<2, ];
      if (ngs>10000) mth <- mth[mth$Speed<1, ];
      
      chc <- as.list(mth[, 1]);
      names(chc) <- rownames(mth);
      if (mt0 %in% unlist(chc, use.names=FALSE)) mt1 <- mt0 else mt1 <- chc[[1]]; 
      updateSelectizeInput(session, 'step3c.method', choices = chc, selected = mt1);
    } else  updateSelectizeInput(session, 'step3c.method', choices = c());
  });
  
  observeEvent(input$step3.button, {
    output$step3.smm.source <- renderText(paste('<font color="#D1B020" size=2>', input$step1.source, '</font>', sep=''));
    output$step3.smm.collection <- renderText(paste('<font color="#D1B020" size=2>', input$step1.collection, '</font>', sep=''));
    output$step3.smm.species <- renderText(paste('<font color="#D1B020" size=2>', input$step1.species, '</font>', sep=''));
    output$step3.smm.gs0 <- renderText(paste('<font color="#D1B020" size=2>', nrow(step1_status$meta), '</font>', sep=''));
    output$step3.smm.gs1 <- renderText(paste('<font color="#D1B020" size=2>', length(input$step1.table_rows_selected), '</font>', sep=''));
    
    if (length(step2_status$list) > 0) typ <- c("A - User's gene list vs. background"=1) else
      if (length(step2_status$top) > 0) typ <- c("B - Selected genes vs. background"=2) else
        if (!is.null(step2_status$table)) typ <- c('C - Compare gene-level statistics'=3) else 
          typ <- c('Unknown'=0);
    step3_status$type <- typ;
    output$step3.smm.type <- renderText(paste('<font color="#D1B020" size=2>', names(typ), '</font>', sep=''));
    
    if (length(step2_status$background) > 0) s1 <- paste(length(unique(step2_status$background)), 'genes') else
      if (!is.null(step2_status$table)) s1 <- paste(length(unique(rownames(step2_status$table))), 'genes') else s1 <- 'Not specified';
    output$step3.smm.background <- renderText(paste('<font color="#D1B020" size=2>', s1, '</font>', sep=''));
    
    if (length(step2_status$list) > 0) s2 <- paste(length(unique(step2_status$list)), 'genes') else s2 <- 'Not applicable';
    output$step3.smm.list <- renderText(paste('<font color="#D1B020" size=2>', s2, '</font>', sep=''));
    
    if (!is.null(step2_status$table)) s3 <- input$step2b.column else s3 <- 'Not applicable';
    output$step3.smm.stat <- renderText(paste('<font color="#D1B020" size=2>', s3, '</font>', sep=''));

    if (!is.null(step2_status$table)) {
      if (length(step2_status$top) > 0) s4 <- paste(length(unique(step2_status$top)), 'genes') else 
        s4 <- 'No selection; use all available genes';
    } else s4 <- 'Not applicable';
    output$step3.smm.top <- renderText(paste('<font color="#D1B020" size=2>', s4, '</font>', sep=''));
    
    if (typ == 3) s0 <- 'Based on the inputs, GSA will compare the gene-level statistics between each gene set and all other genes.' else
      if (typ == 2) s0 <- 'Based on the inputs, GSA will test over-representation of each gene set in selected top genes vs. background.' else
        if (typ == 1) s0 <- 'Based on the inputs, GSA will test over-representation of each gene set in uploaded gene list vs. background.' else s0 <- '';
    output$step3.smm.overall <- renderText(paste('<font color="#D1B020" size=2.5>', s0, '</font>', sep=''));
    
    ################################################################################################
    if (typ==1 | typ==2) {
      ch1 <- c('Full table from Step 1'=1);
      if (length(input$step1.table_rows_selected) > 0) ch1 <- c('Highlighted by user'=0, ch1);
      updateSelectizeInput(session, 'step3ab.collection', choices = ch1);

      ch2 <- c('All known genes'=1, 'All genes in collection'=2);
      if (length(step2_status$background) > 0 | !is.null(step2_status$table)) ch2 <- c('Uploaded by Step 2'=0, ch2);
      updateSelectizeInput(session, 'step3ab.background', choices = ch2);
    } else if (typ == 3) {
      ch1 <- c('Full table from Step 1'=1);
      if (length(input$step1.table_rows_selected) > 0) ch1 <- c('Highlighted by user'=0, ch1); 
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
        updateSelectizeInput(session, 'step3c.type',  choices = stat.type[c(1, 4)]); 
        updateSelectizeInput(session, 'step3c.direction',  choices = ch2); 
        updateSelectizeInput(session, 'step3c.rescale',  choices = resc.type); 
      } else if (rng[1]<0 & rng[2]>0) { # t-like
        updateSelectizeInput(session, 'step3c.type',  choices = stat.type[c(2, 4)]); 
        updateSelectizeInput(session, 'step3c.direction',  choices = list('Not applicable'=-1)); 
        updateSelectizeInput(session, 'step3c.rescale',  choices = resc.type[-3]); 
      } else if (rng[1]>0) { # f-like
        updateSelectizeInput(session, 'step3c.type',  choices = stat.type[c(3, 4)]); 
        updateSelectizeInput(session, 'step3c.direction',  choices = ch2); 
        updateSelectizeInput(session, 'step3c.rescale',  choices = resc.type); 
      } else { # others
        updateSelectizeInput(session, 'step3c.type',  choices = stat.type[c(4, 1:3)]); 
        updateSelectizeInput(session, 'step3c.direction',  choices = ch2); 
        updateSelectizeInput(session, 'step3c.rescale',  choices = resc.type); 
      }
    } else {};
    
    updateCheckboxInput(session, 'step2_show', value=FALSE);
    updateCheckboxInput(session, 'step3_subset', value=as.vector(typ)<3);
    updateCheckboxInput(session, 'step3_show', value=TRUE);
    updateCheckboxInput(session, 'step3_button', value=FALSE);
    updateCheckboxInput(session, 'run_button', value=TRUE);
  });
  
  step3_status;
}