gsagenie.summarize.input <- function(session, input, output, step1_status, step2_status, step3_status) {
  mul <- gsagenie.get.selected(input, step1_status, step3_status);
  
  output$step3.smm.source     <- renderText(paste('<font color="#D1B020" size=2>', input$step1.source, '</font>', sep=''));
  output$step3.smm.collection <- renderText(paste('<font color="#D1B020" size=2>', input$step1.collection, '</font>', sep=''));
  output$step3.smm.species    <- renderText(paste('<font color="#D1B020" size=2>', input$step1.species, '</font>', sep=''));
  output$step3.smm.gs0        <- renderText(paste('<font color="#D1B020" size=2>', length(mul), '</font>', sep=''));
  output$step3.smm.gs1        <- renderText(paste('<font color="#D1B020" size=2>', sum(sapply(mul, length)), '</font>', sep=''));
  
  output$step3.smm.type <- renderText(paste('<font color="#D1B020" size=2>', names(step3_status$type), '</font>', sep=''));
  
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
  
  typ <- as.integer(step3_status$type); 
  if (typ == 3) s0 <- 'Based on the inputs, GSA will compare the gene-level statistics between each gene set and all other genes.' else
    if (typ == 2) s0 <- 'Based on the inputs, GSA will test over-representation of each gene set in selected top genes vs. background.' else
      if (typ == 1) s0 <- 'Based on the inputs, GSA will test over-representation of each gene set in uploaded gene list vs. background.' else s0 <- '';
  output$step3.smm.overall <- renderText(paste('<font color="#D1B020" size=2.5>', s0, '</font>', sep=''));
      
  step3_status;     
}