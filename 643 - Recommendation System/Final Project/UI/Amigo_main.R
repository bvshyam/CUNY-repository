library(dplyr)

return_output <- function(method, userid, count) {

  if(method == 'content_category') {
  output = recommendation_list(userid,count) %>% merge(dfbooks_cfc,"ISBN") %>% select(-Image.URL.S,-Image.URL.M,-Image.URL.L)
  print(userid)
  }
  else if(method=='collabrative'){
    output = getIBCFRecommendation(userid,count) %>% merge(dfbooks_cfc,"ISBN") %>% select(-Image.URL.S,-Image.URL.M,-Image.URL.L)
  }
  else if(method=='content_decade'){
     output = getDecadeBasedRecm(userid,count) %>% select(ISBN=isbn) %>% merge(dfbooks_cfc,"ISBN") %>% select(-Image.URL.S,-Image.URL.M,-Image.URL.L)
  }
  return(output)

}