gsagenie.reset.step3 <- function(session, input, output, step1_status, step2_status, step3_status, event='') {
  if (event == 'go_back') {
    updateCheckboxInput(session, 'detail', value=FALSE);
    updateCheckboxInput(session, 'step2_show', value=TRUE);
    updateCheckboxInput(session, 'step3_button', value=FALSE);
    updateCheckboxInput(session, 'step3_show', value=FALSE);
    updateCheckboxInput(session, 'run_button', value=FALSE);

    step2_status <- gsagenie.reset.step2(session, input, output, step1_status, step2_status, event='clear_all');
    step3_status <- gsagenie.reset.step3(session, input, output, step1_status, step2_status, step3_status, event='clear_all');
    
    output$step2a.msg <- renderText({ NULL; });
    output$step2b.msg <- renderText({ NULL; });
  } else if (event == 'clear_all') {
    step3_status$type <- 0;
    step3_status$method <- NULL;
    step3_status$background <- c();
    step3_status$geneset <- NULL;
    step3_status$result <- NULL;
  } else {}
  
  step3_status;
}; 
