
wellPanel(
  style = 'background-color: #F5F5DC',
  
  titlePanel(
    windowTitle = "GSA-Genie", 
    title = h1(HTML("<font size=20><b>GSA-Genie</b></font>"))
  ),
  
  div(style="display: inline-block;", h2(HTML("<font color='#4B0082' face='Tagesschrift', size=5>Online <u>G</u>ene <u>S</u>et <u>A</u>nalysis</font>"))), 
  div(style="display: inline-block; width: 5px", h5('')),
  div(style="display: inline-block;", h2(HTML("<font color='#4B0082' face='Tagesschrift', size=5><b> - </b></font>"))),
  div(style="display: inline-block; width: 5px", h5('')),
  div(style="display: inline-block;", h4(HTML("<font color='#4B0082' face='Tagesschrift'><b>", geneset.ln, '</font></b>', sep=''))),
  div(style="display: inline-block; width: 10px", h5('')),
  
  div(
    style="display: inline-block;",
    conditionalPanel(condition = 'input.detail == false', 
                     actionLink('detail.show', HTML("<font color='#DC143C' face='Tagesschrift'><b>Show details</b></font>"))),
    conditionalPanel(condition = 'input.detail == true',  
                     actionLink('detail.hide', HTML("<font color='#DC143C' face='Tagesschrift'><b>Hide details</b></font>")))
  ),
  
  conditionalPanel(
    condition = 'input.detail==true',
    tabsetPanel(
      tabPanel(
        title = 'Gene set sources',
        br(),
        DT::dataTableOutput(outputId = 'title.table', width = '100%')
      ),
      tabPanel(
        title = 'Gene set collections',
        br(),
        div(style="display: inline-block;", selectizeInput('title.coll1', NULL, choices=names(collection.smm), width='120px')),
        div(style="display: inline-block; width: 20px", h5('')),
        div(style="display: inline-block;", h6(HTML('<b>Type of collecitons:</b>'))),
        div(style="display: inline-block; width: 1px;", h5('')),
        div(style="display: inline-block;", selectizeInput('title.coll2', NULL, NULL, width='240px')), br(),
        
        DT::dataTableOutput(outputId = 'title.collection', width = '100%')
      ),
      tabPanel(
        title = 'Search gene sets', br(),
        div(style="display: inline-block;", selectizeInput('title.species', NULL, choices=names(metadata.fn), width='120px')),
        div(style="display: inline-block; width: 20px", h5('')),
        div(style="display: inline-block;", h6(HTML('<b>Enter keyword:</b>'))),
        div(style="display: inline-block; width: 1px;", h5('')),
        div(style="display: inline-block;", textInput('title.keyword', NULL, "", width='240px')),
        div(style="display: inline-block; width: 4px;", h5('')),
        div(style="display: inline-block;", actionButton('title.search', '', icon=icon("search"), width='80px', class='dB')), 
        div(style="display: inline-block; width: 10px", h5('')),
        div(style="display: inline-block;", 
            radioButtons('title.exact', NULL, choices=list('Exact match'=1, 'Approximate match'=2), inline=TRUE)),
        br(),
        DT::dataTableOutput(outputId = 'title.found', width = '100%')
      )
    )
  )
)