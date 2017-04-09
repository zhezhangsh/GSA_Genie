####################################################################################################
####################################################################################################
# Step 2
conditionalPanel(
  # condition = 'true',
  condition='input.step2_show == true',
  
  br(),
  wellPanel(
    style = 'background-color: #1DB088',
    
    h2(HTML("<font color='#FFFFFF' face='Tagesschrift'><b>Step 2. Upload user input</b></font>")), 
    
    tabsetPanel(
      type='tabs',

      tabPanel( # Option A
        style = 'color: #000000;',
        
        title=HTML('<font color="tomato" face="Tagesschrift" size=4><b>Option A: Paste gene list</b></font>'), br(),
        div(
          style="display: inline-block; width: 56%; vertical-align: top; line-height: 50%",
          
          div(style="display: inline-block;", h5(HTML("<font face='Tagesschrift'>Choose identifier type:</font>"))),
          div(style="display: inline-block; width: 1px", h5()),
          div(style="display: inline-block;", selectizeInput('step2a.identifier', NULL, id.type, width='165px')),
          div(style="display: inline-block; width: 1px", h5()),
          div(style="display: inline-block;", htmlOutput('step2a.example')), br(),
          
          wellPanel(
            style = "background-color: #FFFFFF; min-height: 280px", 
            h4(HTML('<font color="#1DB088"><b>', 'Tips:', '</b></font>')),
            div(
              style="display: inline-block; width: 95%",
              h6(HTML('<font color="#1DB088"><p style="line-height:150%">', paste(tip2a, collapse='<br>'), '</p></font>'))
            )            
          )
        ),
        div(style="display: inline-block; width: 1%", h5('')),
        div(
          style="display: inline-block; width: 36%; vertical-align: top;",
          # div(style="display: inline-block;", h5(HTML("<font face='Tagesschrift'>Paste</font>"))),
          # div(style="display: inline-block; width: 1px", h5()),
          div(style="display: inline-block; width: 170px", 
              selectizeInput('step2a.paste', NULL, c('Paste a gene list'=1, 'Paste background'=2))),
          # div(style="display: inline-block;", h5(HTML("<font face='Tagesschrift'>,  click to</font>"))),
          div(style="display: inline-block; width: 5px", h6()),
          div(style="display: inline-block;", actionLink('step2a.demo', h6('demo'))),
          div(style="display: inline-block; width: 5px", h5()),
          div(
            style="display: inline-block;", 
            conditionalPanel(
              condition = 'input[["step2a.text"]] != ""',
              actionButton('step2a.button', 'Upload', icon=icon('upload'), style='padding: 6px; font-size: 85%', class='dB'))
          ),
          
          textAreaInput('step2a.text', NULL, width='90%', height='280px')
        ), br(),
        conditionalPanel(
          condition = 'input[["step2a.msg"]]==null',
          style='background-color: white; width: 99%;',
          htmlOutput('step2a.msg')
        )
      ),
      
      tabPanel( # Option B
        style = 'color: #000000',
        
        title=HTML('<font color="tomato" face="Tagesschrift" size=4><b>
                   Option B: Upload a file</b></font>'), br(),
        div(
          style="display: inline-block; width: 40%; vertical-align: top;",
          div(style="display: inline-block;", h5(HTML("<font face='Tagesschrift'>Choose identifier type:</font>"))),
          div(style="display: inline-block; width: 1px", h6()),
          div(style="display: inline-block;", selectizeInput('step2b.identifier', NULL, id.type, width='165px')),
          wellPanel(
            style = "background-color: #FFFFFF",
            h4(HTML('<font color="#1DB088"><b>', 'Tips:', '</b></font>')),
            div(
              style="display: inline-block; width: 95%",
              h6(HTML('<font color="#1DB088"><p style="line-height:150%">', paste(tip2b, collapse='<br>'), '</p></font>'))
            )
          )
        ),
        div(style="display: inline-block; width: 1%", h6()),
        div(
          style="display: inline-block; width: 56%; vertical-align: top; height: 20px",
          uiOutput('step2b.ui', inline = TRUE),
          # fileInput('step2b.file', NULL), 
          div(style="display: inline-block; float: right; padding-right: 5px;", 
              downloadLink('step2b.example', 'Download an example')), br(),
          
          conditionalPanel(
            # condition = 'true',
            condition = 'input[["step2b.column"]]!=""',
            div(style="display: inline-block;", h6(HTML('Choose a column:'))),
            div(style="display: inline-block; width: 1px", h6()), 
            div(style="display: inline-block; width: 36%", selectizeInput('step2b.column', NULL, c())),
            div(style="display: inline-block; width: 5px", h6()), 
            div(style="display: inline-block; color: #D8D8D8;", h6(HTML('(for GSA or top gene selection)'))), br(),
            
            div(style="display: inline-block;", checkboxInput('step2b.filter', "Select top genes")), 
            div(style="display: inline-block; width: 5px", h6()), 
            div(style="display: inline-block; color: #D8D8D8;", h6(HTML("(for over-represetation test of gene sets)"))),
            
            conditionalPanel(
              condition = 'input[["step2b.filter"]] == true',
              sliderInput('step2b.chooser', NULL, -1, 1, value = c(0, 1), ticks=FALSE), 
              
              div(style="display: inline-block;", h6(HTML("Use slider or enter a cutoff:"))),
              div(style="display: inline-block; width: 2px", h6()), 
              div(style="display: inline-block; width: 240px", 
                  isolate(selectizeInput('step2b.direction', NULL, choices=c('Greater_than_or_equal_to'='1', 'Less_than_or_equal_to'='2')))),
              div(style="display: inline-block; width: 2px", h6()), 
              div(style="display: inline-block; width: 80px", isolate(textInput('step2b.cutoff', NULL, NULL))), br()
            )
          )
        ), br(),
        
        conditionalPanel(
          condition = 'input[["step2b.msg"]]==null',
          style='background-color: white;',
          htmlOutput('step2b.msg')
        )
      )
    )
  )
)