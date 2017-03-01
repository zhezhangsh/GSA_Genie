gsagenie.run.t <- function(stt, gst) {
  gid <- names(stt);

  sss <- sapply(gst, function(g) {
    ind <- gid %in% g;
    g0 <- stt[!ind];
    g1 <- stt[ind];
    
    if (length(g0)>1 & length(g1)>1) {
      s <- t.test(g1, g0); 
      t <- s$statistic;
      p <- s$p.value;
      m <- as.vector(s$estimate);
      
      m0 <- m[1];
      m1 <- m[2];
      
      p1 <- p/2;
      p1[m1>m0] <- 1-p1[m1>m0];
      p2 <- 1-p1;
    } else {
      p <- 1;
      t <- 0;
      p1 <- p2 <- 1;
      m0 <- mean(g0, na.rm=TRUE);
      m1 <- mean(g1, na.rm=TRUE); 
    };
    n0 <- length(g1);
    n1 <- length(g1[g1>m0]);
    n2 <- length(g1[g1<m0]);
    
    c(n0, n1, n2, m0, m1, t, p1, p2, p);
  });
  sss <- t(sss);
  sss <- cbind(sss, p.adjust(sss[, ncol(sss)], method='BH'));
  colnames(sss) <- c('Genes_Total', 'Genes_Up', 'Genes_Dn', 'Mean_Geneset', 'Mean_Others', 'Stat_T', 'Pvalue_Up', 'Pvalue_Dn', 'Pvalue', 'FDR');
  
  sss;
}; 

gsagenie.run.ks <- function(stt, gst) {
  options(warn=-1);
  
  gid <- names(stt);
  
  sss <- sapply(gst, function(g) {
    ind <- gid %in% g;
    g0 <- stt[!ind];
    g1 <- stt[ind];
    
    if (length(g0)>1 & length(g1)>1) {
      s <- ks.test(g1, g0); 
      k <- s$statistic;
      p <- s$p.value;
      
      m0 <- mean(g0, na.rm=TRUE);
      m1 <- mean(g1, na.rm=TRUE); 
      
      p1 <- p/2;
      p1[m1>m0] <- 1-p1[m1>m0];
      p2 <- 1-p1;
    } else {
      p <- 1;
      k <- 0;
      
      m0 <- mean(g0, na.rm=TRUE);
      m1 <- mean(g1, na.rm=TRUE); 
      
      p1 <- p2 <- 1;
    };

    n0 <- length(g1);
    n1 <- length(g1[g1>m0]);
    n2 <- length(g1[g1<m0]);
    
    c(n0, n1, n2, m0, m1, k, p1, p2, p);
  });
  
  sss <- t(sss);
  sss <- cbind(sss, p.adjust(sss[, ncol(sss)], method='BH'));
  colnames(sss) <- c('Genes_Total', 'Genes_Up', 'Genes_Dn', 'Mean_Geneset', 'Mean_Others', 'Stat_KS', 'Pvalue_Up', 'Pvalue_Dn', 'Pvalue', 'FDR')
  
  options(warn=1);
  
  sss;
}
