gsagenie.run.setup <- function(session, input, output, step1_status, step2_status, step3_status) {
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
    
    mul <- gsagenie.get.selected(input, step1_status, step3_status);
    ngs <- sum(sapply(mul, length)); 
    if (ngs > geneset.max[1]) mth <- mth[mth$Name!='gsea', , drop=FALSE];
    if (ngs > geneset.max[2]) mth <- mth[mth$Speed<2, ];
    if (ngs > geneset.max[3]) mth <- mth[mth$Speed<1, ];
    
    chc <- as.list(mth[, 1]);
    names(chc) <- rownames(mth);
    if (mt0 %in% unlist(chc, use.names=FALSE)) mt1 <- mt0 else mt1 <- chc[[1]]; 
    updateSelectizeInput(session, 'step3c.method', choices = chc, selected = mt1);
  } else  updateSelectizeInput(session, 'step3c.method', choices = c());
  
  step3_status; 
}