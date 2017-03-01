####################################################################################################
####################################################################################################
# Step 3
conditionalPanel(
  condition='input.step3_show==true',
  # condition='true',
  
  wellPanel(
    style = 'background-color: #D1B020;',
    
    h2(HTML("<font color='#FFFFFF' face='Tagesschrift'><b>Step 3. Run gene set analysis</b></font>")),
    
    wellPanel(
      style = "background-color: #FFFFFF; width: 99%", 
      # h4(HTML("<font color='#D1B020'>Please review inputs for analysis</font>")),
      div(
        style="display: inline-block; width: 48%; vertical-align: top",
        h5(HTML('<font color="#D1B020"><b><u>Gene set</u></b></font>')),
        div(style="display: inline-block; width: 36%; text-align: right; height: 0px;", h6(HTML('Source name :'))),
        div(style="display: inline-block; width: 1%; height: 0px;", h6(HTML(''))),
        div(style="display: inline-block; width: 60%; text-align: left; height: 0px;", htmlOutput('step3.smm.source')), br(),
        div(style="display: inline-block; width: 36%; text-align: right; height: 0px;", h6(HTML('Collection name :'))),
        div(style="display: inline-block; width: 1%; height: 0px;", h6(HTML(''))),
        div(style="display: inline-block; width: 60%; text-align: left; height: 0px;", htmlOutput('step3.smm.collection')), br(),
        div(style="display: inline-block; width: 36%; text-align: right; height: 0px;", h6(HTML('Species name :'))),
        div(style="display: inline-block; width: 1%; height: 0px;", h6(HTML(''))),
        div(style="display: inline-block; width: 60%; text-align: left; height: 0px;", htmlOutput('step3.smm.species')), br(),
        div(style="display: inline-block; width: 36%; text-align: right; height: 0px;", h6(HTML('# of total gene sets :'))),
        div(style="display: inline-block; width: 1%; height: 0px;", h6(HTML(''))),
        div(style="display: inline-block; width: 60%; text-align: left; height: 0px;", htmlOutput('step3.smm.gs0')), br(),
        div(style="display: inline-block; width: 36%; text-align: right; height: 0px;", h6(HTML('# of selected gene sets :'))),
        div(style="display: inline-block; width: 1%; height: 0px;", h6(HTML(''))),
        div(style="display: inline-block; width: 60%; text-align: left; height: 0px;", htmlOutput('step3.smm.gs1')), br()
      ),
      div(
        style="display: inline-block; width: 48%; vertical-align: top",
        h5(HTML('<font color="#D1B020"><b><u>User inputs</u></b></font>')),
        div(style="display: inline-block; width: 36%; text-align: right; height: 0px;", h6(HTML('Analysis type :'))),
        div(style="display: inline-block; width: 1%; height: 0px;", h6(HTML(''))),
        div(style="display: inline-block; width: 60%; text-align: left; height: 0px;", htmlOutput('step3.smm.type')), br(),
        
        div(style="display: inline-block; width: 36%; text-align: right; height: 0px;", h6(HTML('Background :'))),
        div(style="display: inline-block; width: 1%; height: 0px;", h6(HTML(''))),
        div(style="display: inline-block; width: 60%; text-align: left; height: 0px;", htmlOutput('step3.smm.background')), br(),
        
        div(style="display: inline-block; width: 36%; text-align: right; height: 0px;", h6(HTML('Uploaded list (A) :'))),
        div(style="display: inline-block; width: 1%; height: 0px;", h6(HTML(''))),
        div(style="display: inline-block; width: 60%; text-align: left; height: 0px;", htmlOutput('step3.smm.list')), br(),

        div(style="display: inline-block; width: 36%; text-align: right; height: 0px;", h6(HTML('Gene-level statistics (B/C) :'))),
        div(style="display: inline-block; width: 1%; height: 0px;", h6(HTML(''))),
        div(style="display: inline-block; width: 60%; text-align: left; height: 0px;", htmlOutput('step3.smm.stat')), br(),

        div(style="display: inline-block; width: 36%; text-align: right; height: 0px;", h6(HTML('Selected by statistics (B) :'))),
        div(style="display: inline-block; width: 1%; height: 0px;", h6(HTML(''))),
        div(style="display: inline-block; width: 60%; text-align: left; height: 0px;", htmlOutput('step3.smm.top'))
      ), br(), br(),
      htmlOutput('step3.smm.overall')
    ),
    
    conditionalPanel(
      # condition = 'false',
      condition = 'input.step3_subset == true',

      div(
        style="display: inline-block; width: 25%", 
        selectizeInput("step3ab.collection", h6(HTML("<b>Choose gene sets</b>")), choices=c(), width='90%'),
        selectizeInput("step3ab.background", h6(HTML("<b>Choose background</b>")), choices=c(), width='90%'), 
        selectizeInput("step3ab.method", h6(HTML("<b>Choose method</b>")), choices=ora.method, width='90%')
      ),
      div(style="display: inline-block; width: 1%"),
      div(
        style="display: inline-block; width: 72%; vertical-align: top;", 
        br(),
        wellPanel(
          style='background-color: #FFFFFF; min-height: 225px;',
          h4(HTML('<font color="#D1B020"><b>', 'Tips:', '</b></font>')),
          div(
            style="display: inline-block; width: 95%",
            h6(HTML('<font color="#D1B020"><p>', paste(tip3ab, collapse='<br>'), '</p></font>'))
          )
        )
      )
    ),
    
    conditionalPanel(
      # condition = 'true',
      condition = 'input.step3_subset == false',
      div(
        style="display: inline-block; width: 27%", 
        selectizeInput("step3c.collection", h6(HTML("<b>Choose gene sets</b>")), choices=c(), width='90%'),
        selectizeInput("step3c.type", h6(HTML("<b>Choose variable type</b>")), choices=c(), width='90%'),
        selectizeInput("step3c.direction", h6(HTML("<b>Choose direction column</b>")), choices=c(), width='90%'),
        selectizeInput("step3c.rescale", h6(HTML("<b>Choose re-scaling method</b>")), choices=c(), width='90%'),
        selectizeInput("step3c.method", h6(HTML("<b>Choose test method</b>")), choices=c(), width='90%')
      ),
      div(style="display: inline-block; width: 1%"),
      div(
        style="display: inline-block; width: 70%; vertical-align: top;", 
        br(),
        wellPanel(
          style='background-color: #FFFFFF; min-height: 360px;',
          h4(HTML('<font color="#D1B020"><b>', 'Tips:', '</b></font>')),
          div(
            style="display: inline-block; width: 95%",
            h6(HTML('<font color="#D1B020"><p>', paste(tip3c, collapse='<br>'), '</p></font>'))
          )
        )
      )
    )
  )
)
