require(shiny)
# colored buttons and wait timers etc. https://github.com/AnalytixWare/ShinySky
require(shinysky)
# extended javascript support https://deanattali.com/shinyjs/
require(shinyjs)

fluidPage(
  titlePanel("XLSX Zusammenführen"),
  fluidRow(
    column(3,

      wellPanel(
        h4("Datei 1"),
        fileInput('fileOne', 'XLSX auswählen', accept=c('.xlsx','.xlsx')),
        actionButton('importLeft',style="primary",label="Importieren"),
        uiOutput('pagesOne'),
        uiOutput('columnsOne')
        ),

      wellPanel(
        h4("Datei 2"),
        fileInput('fileTwo', 'XLSX auswählen', accept=c('.xlsx','.xlsx')),
        actionButton('importRight',style="primary",label="Importieren"),
        uiOutput('pagesTwo'),
        uiOutput('columnsTwo')
        )
      ),
    column(9,
      wellPanel(
        useShinyjs(), # initialize shinyjs
        actionButton('fuse',style="success",label="Zusammenführen"),
        downloadButton('downloadData',style="warning",label="Download XLSX")
        ),
        div(id="infobox", img(src="infobox.svg",width="100%")),
        dataTableOutput('mergeTab')
      )
    )
  )
