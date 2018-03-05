library(markdown)
library(data.table)
library(stringr)
library(shiny)

load('blogDb.Rdata',.GlobalEnv)
keycols<-c("word1","word2","word3")
setkeyv(blogDb,keycols)

predNext<-function(x){
  
  count<-str_count(x, "\\S+")
  
  if(count > 3){
    x<-word(x,count-2, count)
    count<-str_count(x, "\\S+")
  }
  
  if (count == 3){
    # cat("into 3")
    W1<-word(x,1)
    W2<-word(x,2)
    W3<-word(x,3)
    
    ngram <- blogDb[list(W1,W2,W3)]
    group_var<-c("word4")
    
    if (is.na(ngram$word4[1])){
      x<-word(x,2, 3)
      count=2
    }
    
  }
  
  if (count == 2){
    W1<-word(x,1)
    W2<-word(x,2)
    ngram <- blogDb[list(W1,W2)]
    group_var<-c("word3")
    
    if (is.na(ngram$word3[1])){
      x<-word(x,-1)
      count=1
      
    }
    
  }
  
  
  if (count == 1){
    
    W1<-word(x,1)
    ngram <- blogDb[list(W1)]
    group_var<-c("word2")
    
  }
  
  
  
  if (count==0){
    ngramnew<-c("the","to","and","a","of")
  } else {
    
    ngramnew<-ngram[, .N ,by = group_var][order(-N)][1:5,get(group_var)]   
  }
  return(ngramnew)
  
}

predNextNew<-function(x){
  
  predText<-predNext(x)
  
  for(i in 1:5){
    
    if (is.na(predText[i])){
      count<-str_count(x, "\\S+")
      
      if(count==1){
        x<-""
      }else if(count==2){
        x<-word(x,2)
        
      } else { x<-word(x,count-1,count) }
      
      secPred<-predNext(x)
      
      m<- 6-i
      n<-0
      for (naIndex in 1:5){
        if(is.na(predText[naIndex])){
          if(n==0){
            n<-naIndex
          }
        }
      
      }
      
      for ( j in 1:5){
        
        if (!(secPred[j] %in% predText))
        {
          predText[n]=secPred[j]
          n=n+1
          
        }
      }
      
      
    }
    
    
  }
  
  return(predText)
}


shinyServer(
  function(input, output) {
   
    predVals<-reactive({predNextNew(input$textInp)})
  
    output$nextWord1 = renderText({
   
      nextWord1<-predVals()[1]
      
    })
    output$nextWord2 = renderText({
      
     
      nextWord2<-predVals()[2]
      
    })
    output$nextWord3 = renderText({
      
      nextWord3<-predVals()[3]
      # nextWord3<-paste(predVals()[2],predVals()[3],predVals[4],predVals[5],collapse=",")
      
      
    })
   
    output$nextWord4 = renderText({
      
      nextWord4<-predVals()[4]
      # nextWord3<-paste(predVals()[2],predVals()[3],predVals[4],predVals[5],collapse=",")
      
      
    })
    
    output$nextWord5 = renderText({
      
      nextWord5<-predVals()[5]
      # nextWord3<-paste(predVals()[2],predVals()[3],predVals[4],predVals[5],collapse=",")
      
      
    })
    
    
    output$outcf1 = renderPrint({model$coefficients[[1]]})
    output$outcf2 = renderPrint({model$coefficients[[2]]})
    output$outcf3 = renderPrint({model$coefficients[[3]]})
    output$outcf4 = renderPrint({model$coefficients[[4]]})
    output$modsum = renderPrint({summary(model)})
    
    output$outmpg <- renderPrint({ 
      
      df1$cyl <- as.numeric(input$cyl)
      df1$wt <- input$wt
      df1$qsec <- input$qsec
      df1$predicted<-predict(model, newdata=df1)
      paste("The predicted MPG is  :", df1$predicted)})
    
    
  }
  
)
