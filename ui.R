shinyUI(pageWithSidebar(
        headerPanel("SwiftKey Predict Next word"),
        sidebarPanel(
                textInput("textInp", "Please Type Text here","sample text"),
                h6('The next word will be predicted based on the text you type here'),
                # h6('Please type and see.'),

#                           textInput("textInp1", "Please Type Text here","of"),
                 strong(h3('Instructions')),
                 h5('1. Please type a text .'),
                 h5('2. As and when you type a text, the next word will be predicted'),
                 h5('3. The top prediction is shown and other possible words are also displayed .')
                
        ),
#         sidebarPanel(
#           textInput("textInp1", "Please Type Text here","of"),
#           h6('The next word will be predicted based on the text you type here'),
#           h6('Please type and see.')
#           
#           
#         ),
        mainPanel(
                
                tabsetPanel(type = "tabs", 
                            tabPanel("Predictions", 
                                     strong(h4('The top predicted word is:')),
                                     em(h3(textOutput("nextWord1"))),
                                     br(),
                                     

                                     h4('Other possible predictions are:'),
                                     em(h3(textOutput("nextWord2"))),
                                     # h4('The predicted word 3 is'),
                                     em(h3(textOutput("nextWord3"))),
                                     em(h3(textOutput("nextWord4"))),
                                     # h4('The predicted word 3 is'),
                                     em(h3(textOutput("nextWord5")))),
#                           
#                             

                            tabPanel("Model Algorithm",
                                           mainPanel(
                                            includeMarkdown("About.md"))),
                            tabPanel("Reports", 
                                     # HTML("<hr>"),  # Add a line
                                     h4("The milestone report is available at", 
                                        a("Rpubs Report", 
                                          href="http://www.rpubs.com/elankumaran/SwiftKey"))

                            
                                     
                            )
                )
        )
))
