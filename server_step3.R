server_step3 <- function(input, output, session, step1_status, step2_status, step3_status) { 
  observeEvent(input$step3.back, {
    step2_status <- gsagenie.reset.step2(session, input, output, step1_status, step2_status, event='go_back');
  });
  
  observeEvent(c(input$step3c.type, input$step3c.direction, input$step3c.rescale), {
    step3_status <- gsagenie.run.setup(session, input, output, step1_status, step2_status, step3_status)
  });
  
  observeEvent(input$step3.button, {
    step3_status <- gsagenie.run.option(session, input, output, step1_status, step2_status, step3_status);
    step3_status <- gsagenie.summarize.input(session, input, output, step1_status, step2_status, step3_status);
  })
  
  step3_status;
}