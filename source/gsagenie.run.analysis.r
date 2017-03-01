gsagenie.run.analysis <- function(input, step1_status, step2_status, step3_status) {
  require(DEGandMore);
  
  ch1 <- as.integer(input$step3ab.collection);
  ch2 <- as.integer(input$step3ab.background);
  ch3 <- as.integer(input$step3ab.method);
  spe <- input$step1.species;
  idf <- input$step2a.identifier;
  if (length(step2_status$list) > 0) gns <- step2_status$list else gns <- step2_status$top;
  gst <- gsagenie.get.mapping(GENESET_HOME, input$step1.source, input$step1.collection, spe, idf);
  
  typ <- step3_status$type;
  if (typ == 3) {
    tbl <- step2_status$table;
    cnm <- input$step2b.column;
    vrb <- as.integer(input$step3c.type);
    dir <- as.integer(input$step3c.direction);
    rsc <- as.integer(input$step3c.rescale);
    mth <- input$step3c.method;
    
    ch1 <- as.integer(input$step3c.collection);
    if (ch1==1) gst <- gst[rownames(step1_status$meta)] else {
      sel <- input$step1.table_rows_selected;
      gst <- gst[rownames(step1_status$meta)[sel]]; 
    }; 
    
    tbl <- tbl[!is.na(tbl[, cnm]), , drop=FALSE];
    stt <- tbl[, cnm];
    names(stt) <- rownames(tbl); 
    if (vrb==1 & min(stt)==0) stt[stt==0] <- min(stt[stt>0]);
    
    toNorm <- function(d) {
      c <- qnorm(rank(-abs(d))/length(d)/2, lower.tail = FALSE);
      c <- sign(d)*c;
      c;
    }; 
    
    if (rsc > 0) {
      if (vrb == 1) stt <- -log10(abs(stt));
      if (dir > 0) stt <- sign(tbl[, dir])*stt;
      
      if (rsc == 1) stt <- toNorm(stt) else if (rsc == 2) stt <- sign(stt)*log10(abs(stt)) else if (rsc == 3) stt <- rank(stt);
      dir <- NULL;
    } else {
      if (dir > 0) {
        dir <- tbl[, dir];
        names(dir) <- rownames(tbl); 
      } else dir <- NULL;
    };
    sig <- as.vector(gsa.method[gsa.method[,1]==mth, 'Significance']);
    
    if (mth == 't') { 
      tbl <- gsagenie.run.t(stt, gst);
      # tbl <- data.frame(Name=step1_status$meta[names(gst), 'Name'], tbl, stringsAsFactors = FALSE);
    } else if (mth == 'ks') { 
      tbl <- gsagenie.run.ks(stt, gst);
      # tbl <- data.frame(Name=step1_status$meta[names(gst), 'Name'], tbl, stringsAsFactors = FALSE);
    } else if (mth %in% gsa.method[, 1]) {
      gsc <- gsc.skelet;
      gsc[[1]] <- gst;
      gsc[[2]] <- data.frame(X1=names(gst), X2=step1_status$meta[names(gst), 'Name'], stringsAsFactors = FALSE);
      if (length(gst)>100) nperm <- 1000 else if (length(gst)>25) nperm <- 5000 else nperm <- 10000;
      if (mth=='gsea') nperm <- 1000;
      
      # saveRDS(list(geneLevelStats=stt, directions=dir, geneSetStat=mth, signifMethod=sig, adjMethod="fdr", gsc=gsc), 'x.rds');
      # saveRDS(list(stt, dir), 'x.rds');
      
      library(piano);
      ###########################################################################################################################################
      res <- runGSA(geneLevelStats=stt, directions=dir, geneSetStat=mth, signifMethod=sig, adjMethod="fdr", gsc=gsc, nPerm=nperm, verbose=FALSE);      
      ###########################################################################################################################################
      gid <- names(res$gsc);
      gns <- do.call('cbind', lapply(res[grep('^nGenes', names(res))], function(x) x[, 1]));
      sta <- do.call('cbind', lapply(res[grep('^stat', names(res))], function(x) x[, 1]));
      pvl <- do.call('cbind', lapply(res[grep('^p',  names(res))], function(x) x[, 1]));
      tbl <- cbind(gns, sta, pvl);
      colnames(tbl)[1:3] <- c('Genes_Total', 'Genes_Up', 'Genes_Dn');
      colnames(tbl)[4:9] <- c('Stat_Distinct', 'Stat_Distinct_Up', 'Stat_Distinct_Dn', 'Stat_Non_Directional', 'Stat_Mixed_Up', 'Stat_Mixed_Dn');
      colnames(tbl)[10:14] <- c("P_Distinct_Up", "P_Distinct_Dn", "P_Non_Directional", "P_Mixed_Up", "P_Mixed_Dn");
      colnames(tbl)[15:19] <- c("FDR_Distinct_Up", "FDR_Distinct_Dn", "FDR_Non_Directional", "FDR_Mixed_Up", "FDR_Mixed_Dn");
      tbl <- tbl[, apply(tbl, 2, function(x) length(x[!is.na(x)])>0)]; 
      rownames(tbl) <- names(res$gsc);
    } else {
      tbl <- NULL;
    }

    step3_status$result <- tbl;
    step3_status$stat <- stt;
    step3_status$method <- rownames(gsa.method)[gsa.method[, 1]==mth];
    step3_status$subset <- c();
    step3_status$background <- c();
    step3_status$metadata <- step1_status$meta[names(gst), , drop=FALSE];
    step3_status$geneset <- gst; 
  } else if (typ==2 | typ==1) {
    ch1 <- as.integer(input$step3ab.collection);
    ch2 <- as.integer(input$step3ab.background);
    ch3 <- as.integer(input$step3ab.method);
    spe <- input$step1.species;
    idf <- input$step2a.identifier;
    if (length(step2_status$list) > 0) gns <- step2_status$list else gns <- step2_status$top;
    gst <- gsagenie.get.mapping(GENESET_HOME, input$step1.source, input$step1.collection, spe, idf);
 
    if (ch2 == 2) bgd <- unique(unlist(gst, use.names=FALSE)) else 
      if (ch2 == 1) bgd <- readRDS(paste(GENE_HOME, '/', spe, '_just_id_', idf, '.rds', sep='')) else {
        if (length(step2_status$background) > 0) bgd <- step2_status$background else bgd <- unique(rownames(step2_status$table))
      }

    if (ch1==1) gst <- gst[rownames(step1_status$meta)] else {
      sel <- input$step1.table_rows_selected;
      gst <- gst[rownames(step1_status$meta)[sel]]; 
    }; 
    
    step3_status$result <- OraWrapper(gns, gst, bgd, ch3);
    step3_status$method <- names(ora.method)[ch3];
    step3_status$subset <- gns;
    step3_status$background <- bgd;
    step3_status$metadata <- step1_status$meta[names(gst), , drop=FALSE];
    step3_status$geneset <- gst;
    # list(method=names(ora.method)[ch3], result=step3_status$result, subset=gns, background=bgd, geneset=gst)
  } else step3_status$result <- step3_status$subset <- step3_status$method <- step3_status$background <- step3_status$geneset <- step3_status$metadata <- NULL;
  
  step3_status;
}