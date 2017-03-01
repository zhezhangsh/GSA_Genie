#####################
### GSA Genie #######
#####################
source("/srv/shiny-server/gsagenie/preload.R");

shinyUI(
  fluidPage(
    theme = shinythemes::shinytheme("united"),
    
    tags$head(
      tags$style(HTML("h1{text-shadow: 0 1px 0 #ccc, 0 2px 0 #c9c9c9, 0 3px 0 #bbb, 0 4px 0 #b9b9b9,
                        0 5px 0 #aaa, 0 6px 1px rgba(0,0,0,.1), 0 0 5px rgba(0,0,0,.1), 0 1px 3px rgba(0,0,0,.3),
                        0 3px 5px rgba(0,0,0,.2), 0 5px 10px rgba(0,0,0,.25), 0 10px 10px rgba(0,0,0,.2),
                        0 20px 20px rgba(0,0,0,.15); color: #666666; font-family: Tagesschrift;}")),
      tags$style(".dE{background-color: #3CB371; border: 1px solid #bfbfbf; box-shadow: inset 0 1px 0 white,
                    inset 0 -1px 0 #d9d9d9, inset 0 0 0 1px #f2f2f2, 0 2px 4px rgba(0, 0, 0, 0.2);
                 color: white; text-shadow: 0 1px 0 rgba(255, 255, 255, 0.5); border-radius: 3px;
                 cursor: pointer; display: inline-block; font-family: Verdana, sans-serif; font-size: 12px;
                 font-weight: 400; line-height: 20px; padding: 9px 16px 9px; margin: 0px 0 0 0px;
                 transition: all 20ms ease-out;}"),
      tags$style(".dD{background-color: #6495ED; border: 1px solid #bfbfbf; box-shadow: inset 0 1px 0 white,
                    inset 0 -1px 0 #d9d9d9, inset 0 0 0 1px #f2f2f2, 0 2px 4px rgba(0, 0, 0, 0.2);
                 color: white; text-shadow: 0 1px 0 rgba(255, 255, 255, 0.5); border-radius: 3px;
                 cursor: pointer; display: inline-block; font-family: Verdana, sans-serif; font-size: 12px;
                 font-weight: 400; line-height: 20px; padding: 9px 16px 9px; margin: 0px 0 0 0px;
                 transition: all 20ms ease-out;}"),
      tags$style(".dC{background-color: #FF6347; border: 1px solid #bfbfbf; box-shadow: inset 0 1px 0 white,
                    inset 0 -1px 0 #d9d9d9, inset 0 0 0 1px #f2f2f2, 0 2px 4px rgba(0, 0, 0, 0.2);
                 color: white; text-shadow: 0 1px 0 rgba(255, 255, 255, 0.5); border-radius: 3px;
                 cursor: pointer; display: inline-block; font-family: Verdana, sans-serif; font-size: 12px;
                 font-weight: 400; line-height: 20px; padding: 9px 16px 9px; margin: 0px 0 0 0px;
                 transition: all 20ms ease-out;}"),
      tags$head(
        tags$style(".dB{background-color: #666666; border: 1px solid #bfbfbf; box-shadow: inset 0 1px 0 white,
                   inset 0 -1px 0 #d9d9d9, inset 0 0 0 1px #f2f2f2, 0 2px 4px rgba(0, 0, 0, 0.2);
                   color: white; text-shadow: 0 1px 0 rgba(255, 255, 255, 0.5); border-radius: 3px;
                   cursor: pointer; display: inline-block; font-family: Verdana, sans-serif; font-size: 12px;
                   font-weight: 400; line-height: 20px; padding: 9px 16px 9px; margin: 0px 0 0 0px;
                   transition: all 20ms ease-out;}"))
    ),
    
    # Always hidden, for condition flags
    conditionalPanel(
      condition='false', 
      checkboxInput('detail', NULL, value=FALSE),
      checkboxInput('step1_show',  NULL, value=TRUE),
      checkboxInput('step2_show',  NULL, value=FALSE),
      checkboxInput('step3_show',  NULL, value=FALSE),
      checkboxInput('step3_button', NULL, value=FALSE),
      checkboxInput('step3_subset', NULL, value=FALSE),
      checkboxInput('run_button', NULL, value=FALSE),
      checkboxInput('result_show', NULL, value=FALSE),
      checkboxInput('result_plot', NULL, value=FALSE),
      checkboxInput('result_button', NULL, value=FALSE)
    ),
    
    source('ui_title.R', local=TRUE)$value,
    
    source('ui_step1.R', local=TRUE)$value,
    
    conditionalPanel(
      condition='input.step1_show == true',
      actionButton('step2.button', 'Go forward to step 2', icon=icon('step-forward'), class='dC')
    ),
    
    source('ui_step2.R', local=TRUE)$value, 
    
    div(
      style="display: inline-block;",
      conditionalPanel(
        condition='input.step2_show == true && input.step3_show == false',
        actionButton('step3.back', 'Go back to step 1', icon=icon('step-backward'), class='dD')
      )
    ),
    div(style="display: inline-block; width: 10px;", h6()),
    div(
      style="display: inline-block;", 
      conditionalPanel(
        condition='input.step3_button == true',
        actionButton('step3.button', 'Go forward to step 3', icon=icon('step-forward'), class='dC')
      )
    ), 
    
    source('ui_step3.R', local=TRUE)$value, 
    
    conditionalPanel(
      # condition='true',
      condition='input.run_button == true',
      div(style="display: inline-block;", actionButton('run.back', 'Go back to step 2', icon=icon('step-backward'), class='dD')),
      div(style="display: inline-block; width: 10px;", h6()),
      div(style="display: inline-block;", actionButton('run.button', 'Start analysis', icon=icon('step-forward'), class='dC'))
    ), 
    
    source('ui_result.R', local=TRUE)$value, 
    
    conditionalPanel(
      # condition='true',
      condition='input.result_button == true',
      div(style="display: inline-block;", actionButton('result.back', 'Go back to step 3', icon=icon('step-backward'), class='dD')),
      div(style="display: inline-block; width: 10px;", h6()),
      div(style="display: inline-block;", actionButton('startover.button', 'Start over', icon=icon('refresh'), class='dE')),
      div(style="display: inline-block; width: 5px;", h6()),
      div(style="display: inline-block; color: #666666; vertical-align: bottom;", 
          h6(HTML("<b><u>Result will be lost; download table if want to keep it.</u></b>")))
    ),
   
    br(), br(),
    div(style="display: inline-block; line-height:15px; font-family: Tagesschrift;", 
        h5(HTML('<a href="http://awsomics.org" target="_blank">[Awsomics home]</a>'))),
    div(style="display: inline-block; width: 5px", h6()),
    div(style="display: inline-block; line-height:15px; font-family: Tagesschrift;", 
        h5(HTML('<a href="mailto:zhangz@email.chop.edu">[Contact us]</a>')))
  ) # end of fluidPage
) # end of shinyUI
