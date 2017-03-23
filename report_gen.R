
# Pass full path, possibly with tilde
args <- commandArgs(trailingOnly = TRUE)
fastq_dir <- as.character(args[1])
print(fastq_dir)
setwd(fastq_dir)

library(jsonlite)

OUT <- list()

all_fnames <- list.files()
fnames <- all_fnames[grepl("(\\.fastq\\.gz)$", all_fnames)]
fstem <- gsub("(\\.fastq\\.gz)$", "", fnames)
fhtml <- paste0(fstem, "_fastqc.html")
fzip <- paste0(fstem, "_fastqc.zip")
funzip <- paste0(fstem, '_fastqc')


if( !all(c(length(fnames), length(fstem), length(fhtml)) == length(fzip)) ){
  print(c(length(fnames), length(fstem), length(fhtml), length(fzip)))
  stop('Unequal length in vector of file names.')
}

nfiles <- length(fnames)

for( i in 1:nfiles ){
  
  #OUT[[fstem[i]]] <- list()
  
  fastq_call <- paste0("fastqc ", fnames[i])
  system(fastq_call)
  cat("\n\n##### FASTQC CALL COMPLETE #####\n\n")
  
  zip_exists <- sum(grepl(fzip[i], list.files())) == 1
  if( !zip_exists ){
    stop(paste0("Zip file not generated for ", fnames[i]))
  }
  unzip_call <- paste0("unzip ", fzip[i])
  system(unzip_call)
  cat("\n\n##### UNZIP COMPLETE #####\n\n")

  
  #unzipped_exists <- sum(grepl(funzip[i] , list.files())) == 1
  #if( !unzipped_exists ){
  #  stop(paste0("Unzipped directory not generated for ", fnames[i]))
  #} else {
  #  cat("\n\n##### UNZIPPED DIRECTORY VERIFIED TO EXIST #####\n\n")
  #}
  
  
  html_exists <- sum(grepl(fhtml[i], list.files())) == 1
  if( !html_exists ){
    stop(paste0("HTML file not generated for ", fnames[i]))
  } else {
    cat("\n\n##### HTML VERIFIED TO EXIST #####\n\n")
  }
  
  summary_path <- paste0(funzip[i], '/summary.txt')
  summary_exists <- sum(grepl('summary.txt', list.files(funzip[i]))) == 1
  if( !summary_exists ){
    stop(paste0("Summary file not generated for ", funzip[i]))
  } else {
    cat("\n\n##### SUMMARY VERIFIED TO EXIST #####\n\n")
  }  
  
  print(summary_path)
  sum_tab <- read.csv(file = summary_path, sep = "\t", header = FALSE)
  names(sum_tab) <- c("grade", "test", "filename")
  sum_tab['filename'] <- NULL
  
  OUT[[paste0(fstem[i], '_summary')]] <- sum_tab
  

  
  adapt_path <- paste0(funzip[i], '/fastqc_data.txt')
  adapt_exists <- sum(grepl('fastqc_data.txt', list.files(funzip[i]))) == 1
  if( !adapt_exists ){
    stop(paste0("Adapt file not generated for ", funzip[i]))
  } else {
    cat("\n\n##### ADAPT VERIFIED TO EXIST #####\n\n")
  }  
  
  print(adapt_path)
  adapt_tab <- readLines(con = adapt_path)
  
  over_line_no <- which(grepl(">>Overrepresented sequences", adapt_tab))[1]
  if(length(over_line_no) == 0){
    cat("\n\n\n######## OVERRESPRESENTED SEQUENCES NOT FOUND ############\n\n\n")
  } else {
    cat("\n\n\n########## Overrespresented sequence found ############\n\n\n")
    
    end_module_line_no <- which(grepl(">>Adapter Content", adapt_tab))[1] - 1
    if(length(end_module_line_no) == 0){
      end_module_line_no <- over_line_no + 3
    }
    
    OVER <- NULL
    
    if( end_module_line_no - over_line_no <= 1 ){
      print('No overrepresented sequences detected.')
    } else {
      for( j in (over_line_no+2):(end_module_line_no-1) ){
        
        temp <- unlist(strsplit(adapt_tab[j], split = '\t'))
        
        print(temp)
        
        temp[2] <- as(temp[2], 'numeric')
        temp[3] <- as(temp[3], 'numeric')
        
        names(temp) <- c('Sequence', 'Count', 'Percentage', 'Possible Source')
        
        if(is.null(OVER)){
          OVER <- data.frame(matrix(temp, nrow = 1, ncol = 4))
          names(OVER) <- names(temp)
        } else {
          out_df <- data.frame(matrix(temp, nrow = 1, ncol = 4))
          names(out_df) <- names(temp)
          if( all.equal(names(OVER), names(out_df)) ){
            print("Names verified to be equal ahead of rbind call")
          }
          OVER <- rbind(OVER, out_df)
        }
        
      }
      
    }
    
    OUT[[paste0(fstem[i], '_overrepresented')]] <- OVER
    
    
    
  }
  
  
  
  json_obj <- toJSON(OUT, pretty = TRUE)
  writeLines(json_obj, 'summary.json')
  cat("\n\n\n##### JSON FILE UPDATED #####\n\n\n")
  
}








