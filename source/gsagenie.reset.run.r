gsagenie.reset.run <- function(session, input, output, step1_status, step2_status, step3_status, result_status, event='') {
  if (event == 'go_back') {
    updateCheckboxInput(session, 'run_button', value=TRUE);
    updateCheckboxInput(session, 'step3_show', value=TRUE);
    updateCheckboxInput(session, 'result_show', value=FALSE);
    updateCheckboxInput(session, 'result_plot', value=FALSE);
    updateCheckboxInput(session, 'result_button', value=FALSE);
    step3_status$result <- NULL;
    result_status$geneset <- NULL;
  } else {}
  
  result_status
}