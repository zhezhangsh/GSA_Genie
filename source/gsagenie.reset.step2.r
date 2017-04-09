gsagenie.reset.step2 <- function(session, input, output, step1_status, step2_status, event='') {
  if (event == 'go_back') {
    updateCheckboxInput(session, 'detail', value=FALSE);
    updateCheckboxInput(session, 'step1_show', value=TRUE);
    updateCheckboxInput(session, 'step2_show', value=FALSE);
    updateCheckboxInput(session, 'step3_button', value=FALSE);
    updateCheckboxInput(session, 'step1.multiple', value=FALSE);
    
    step2_status <- gsagenie.reset.step2(session, input, output, step1_status, step2_status, event='clear_all');
    
    output$step2a.msg <- renderText({ NULL; });
    output$step2b.msg <- renderText({ NULL; });
  }
  if (event == 'clear_all') {
    msg <- paste('<font color="tomato" size=2>User changed gene identifier type; all inputs removed; please reload.</font>', sep='');
    if (length(step2_status$list)>0 | length(step2_status$background>0)) 
      output$step2a.msg <- renderText(paste('<SPAN style="margin: 8px">', msg, '</SPAN>', sep=''));
    if (!is.null(step2_status$table))
      output$step2b.msg <- renderText(paste('<SPAN style="margin: 8px">', msg, '</SPAN>', sep=''));
    
    
    step2_status$list <- c();
    step2_status$background <- c();
    step2_status$top <- c();
    step2_status$table <- NULL;
    
    output$step2b.ui <- renderUI(fileInput('step2b.file', NULL));
    updateCheckboxInput(session, 'detail', value=FALSE);
    updateCheckboxInput(session, 'step3_button', value=FALSE);
    updateTextAreaInput(session, 'step2a.text', value="");
    updateSelectizeInput(session, 'step2b.column', choices = '');
    updateCheckboxInput(session, 'step2b.filter', value=FALSE); 
    updateTextInput(session, 'input$step2b.cutoff', value='');
  } else if (event == 'step2a_button') {
    step2_status$top <- c();
    step2_status$table <- NULL;
    
    output$step2b.ui <- renderUI(fileInput('step2b.file', NULL));
    output$step2b.msg <- renderText(NULL);
    updateCheckboxInput(session, 'detail', value=FALSE);
    updateTextAreaInput(session, 'step2a.text', value="");
    updateSelectizeInput(session, 'step2b.column', choices = '');
    updateCheckboxInput(session, 'step2b.filter', value=FALSE); 
    updateTextInput(session, 'input$step2b.cutoff', value='');
    updateSelectizeInput(session, 'step2b.column', choices = '');
    if (length(step2_status$list)>1) updateCheckboxInput(session, 'step3_button', value=TRUE) else
      updateCheckboxInput(session, 'step3_button', value=FALSE);
  } else if (event == 'step2b_file') {
    step2_status$top <- c();
    step2_status$list <- c();
    step2_status$background <- c();
    
    if (!is.null(step2_status$table)) {
      updateCheckboxInput(session, 'step3_button', value=TRUE);
    } else {
      updateCheckboxInput(session, 'step3_button', value=FALSE);
      updateSelectizeInput(session, 'step2b.column', choices = '');
    }
    updateCheckboxInput(session, 'detail', value=FALSE);
    updateCheckboxInput(session, 'step2b.filter', value=FALSE); 
    updateTextAreaInput(session, 'step2a.text', value="");
    updateTextInput(session, 'input$step2b.cutoff', value='');
    output$step2a.msg <- renderText(NULL);
  } else {}
  
  step2_status;
}